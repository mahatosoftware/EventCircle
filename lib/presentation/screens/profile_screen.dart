import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _editing = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _hydrate(UserModel user) {
    if (_nameController.text.isEmpty) _nameController.text = user.name;
    if (_phoneController.text.isEmpty) _phoneController.text = user.phone;
  }

  Future<void> _save(UserModel current) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final updated = current.copyWith(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      await ref.read(userRepositoryProvider).upsertUser(updated);
      if (mounted) {
        setState(() {
          _editing = false;
          _nameController.clear();
          _phoneController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          userAsync.maybeWhen(
            data: (user) => user == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: _editing ? 'Cancel' : 'Edit',
                    icon: Icon(_editing ? Icons.close : Icons.edit_outlined),
                    onPressed: _saving
                        ? null
                        : () {
                            setState(() {
                              _editing = !_editing;
                              _nameController.clear();
                              _phoneController.clear();
                            });
                          },
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load profile: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }

          if (_editing) _hydrate(user);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ProfileHeader(user: user),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          enabled: _editing && !_saving,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: user.email,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          enabled: _editing && !_saving,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_editing)
                          FilledButton(
                            onPressed: _saving ? null : () => _save(user),
                            child: _saving
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Save'),
                          )
                        else
                          OutlinedButton.icon(
                            onPressed: () {
                              ref.read(authRepositoryProvider).logout();
                              context.go('/login');
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final initial = user.name.trim().isEmpty ? '?' : user.name.trim()[0].toUpperCase();

    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          child: Text(initial, style: const TextStyle(fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name.isEmpty ? 'User' : user.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(user.id, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

