import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../providers/auth_provider.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _subject = 'General Feedback';
  bool _submitting = false;

  final List<String> _subjects = [
    'General Feedback',
    'Report a Bug',
    'Feature Suggestion',
    'Billing/Contribution Query',
    'Other',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final user = ref.read(currentUserProvider);

    try {
      final ticketId = const Uuid().v4();
      await FirebaseFirestore.instance.collection('support_tickets').doc(ticketId).set({
        'id': ticketId,
        'userId': user?.id ?? 'anonymous',
        'userName': user?.name ?? 'Anonymous',
        'userEmail': user?.email ?? 'N/A',
        'subject': _subject,
        'message': _messageController.text.trim(),
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Your feedback has been sent.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send feedback: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'How can we help you?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'We love hearing from our users. Whether it\'s a suggestion, a bug report, or just a hello, feel free to reach out!',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: _subject,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  prefixIcon: const Icon(Icons.subject),
                ),
                items: _subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _subject = val!),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Message',
                  alignLabelWithHint: true,
                  hintText: 'Tell us what\'s on your mind...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Icon(Icons.message_outlined),
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a message' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _submitting
                    ? const CircularProgressIndicator()
                    : const Text('Send Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
