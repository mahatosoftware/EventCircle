import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/member_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/access_control_provider.dart';
import '../../data/models/member_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class MembersScreen extends ConsumerStatefulWidget {
  final String eventId;
  const MembersScreen({super.key, required this.eventId});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  bool _isSubmitting = false;

  Future<void> _pickFromContacts(
    BuildContext context,
    TextEditingController nameCtrl,
    TextEditingController phoneCtrl,
    void Function(void Function()) setDialogState,
  ) async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact permission required')),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final contact = await showDialog<Contact>(
      context: context,
      builder: (context) => const _ContactPickerListDialog(),
    );

    if (contact != null) {
      setDialogState(() {
        nameCtrl.text = contact.displayName;
        if (contact.phones.isNotEmpty) {
          phoneCtrl.text = contact.phones.first.number;
        }
      });
    }
  }

  void _showGuestSettings(BuildContext context, EventModel event, {required bool canEdit}) {
    final maxGuestsController = TextEditingController(text: event.maxGuests?.toString() ?? '');
    final categoriesController = TextEditingController(text: event.guestCategories.join(', '));
    bool rsvpRequired = event.isRsvpRequired;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Guest Management Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: maxGuestsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Maximum Expected Guests', prefixIcon: Icon(Icons.people_outline)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoriesController,
                decoration: const InputDecoration(
                  labelText: 'Guest Categories (comma separated)', 
                  hintText: 'Family, VIP, Members',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Require RSVP Confirmation'),
                subtitle: const Text('Track who is attending, maybe, or declined'),
                value: rsvpRequired,
                onChanged: (val) => setDialogState(() => rsvpRequired = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: !canEdit
                    ? null
                    : () async {
                  final catList = categoriesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                  final updatedEvent = event.copyWith(
                    maxGuests: int.tryParse(maxGuestsController.text),
                    guestCategories: catList,
                    isRsvpRequired: rsvpRequired,
                  );
                  await ref.read(eventRepositoryProvider).updateEvent(updatedEvent);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Save Settings'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  final suggestion = EventTemplateService.getSuggestedGuestSettings(event.category);
                  maxGuestsController.text = suggestion.maxGuests.toString();
                  categoriesController.text = suggestion.categories.join(', ');
                  setDialogState(() => rsvpRequired = suggestion.rsvpRequired);
                },
                icon: const Icon(Icons.tips_and_updates_outlined),
                label: const Text('Apply Suggested Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersForEventStreamProvider(widget.eventId));
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    final canEditGuests = ref.watch(
      hasModuleAccessProvider((eventId: widget.eventId, module: EventModules.guests, required: ModuleAccessLevel.edit)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendee Management'),
        actions: [
          eventAsync.maybeWhen(
            data: (event) => event != null ? IconButton(
              icon: const Icon(Icons.settings_suggest_outlined),
              tooltip: 'Guest Settings',
              onPressed: canEditGuests ? () => _showGuestSettings(context, event, canEdit: true) : null,
            ) : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV Bulk upload enabled')));
            },
          ),
        ],
      ),
      body: membersAsync.when(
        data: (members) {
          if (members.isEmpty) return _buildNoMembers(context);

          // Get counts
          final attending = members.where((m) => m.rsvpStatus == RsvpStatus.attending).length;
          final totalHeads = members.where((m) => m.rsvpStatus == RsvpStatus.attending).fold(0, (sum, m) => sum + 1 + m.plusOnes);

          return Column(
            children: [
              if (eventAsync.value?.maxGuests != null) 
                _buildHeadcountSummary(attending, totalHeads, eventAsync.value!.maxGuests!),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return _buildMemberTile(context, member, ref, canUpdateGuests: canEditGuests);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !canEditGuests
            ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No permission to add guests')))
            : () => _showAddMemberDialog(context, ref, eventAsync.value?.guestCategories ?? []),
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }

  Widget _buildHeadcountSummary(int rsvpCount, int headCount, int max) {
    final progress = headCount / (max == 0 ? 1 : max);
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50]?.withAlpha(128),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Projected Headcount: $headCount / $max', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
              Text('$rsvpCount RSVPed', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white,
            color: progress > 0.9 ? Colors.red : Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMembers(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey.withAlpha(128)),
          const SizedBox(height: 16),
          const Text('No attendees added yet'),
        ],
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, MemberModel member, WidgetRef ref, {required bool canUpdateGuests}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withAlpha(30)),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(member.guestCategory).withAlpha(40),
          child: Text(member.name[0], style: TextStyle(color: _getCategoryColor(member.guestCategory))),
        ),
        title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${member.guestCategory ?? "No Category"} • ${member.phone}'),
        trailing: _buildRsvpChip(member.rsvpStatus),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Plus-ones: ${member.plusOnes}', style: const TextStyle(fontSize: 12)),
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove_circle_outline, size: 18), 
                          onPressed: canUpdateGuests ? () => _updatePlusOnes(member, member.plusOnes - 1) : null),
                        IconButton(icon: const Icon(Icons.add_circle_outline, size: 18), 
                          onPressed: canUpdateGuests ? () => _updatePlusOnes(member, member.plusOnes + 1) : null),
                      ],
                    )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: RsvpStatus.values.where((v) => v != RsvpStatus.none).map((status) {
                    final isSelected = member.rsvpStatus == status;
                    return ChoiceChip(
                      label: Text(status.displayName, style: const TextStyle(fontSize: 10)),
                      selected: isSelected,
                      onSelected: !canUpdateGuests
                          ? null
                          : (val) {
                              if (val) _updateRsvp(member, status);
                            },
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _updatePlusOnes(MemberModel member, int count) {
    if (count < 0) return;
    final updated = member.copyWith(plusOnes: count);
    ref.read(memberRepositoryProvider).updateMember(updated);
  }

  void _updateRsvp(MemberModel member, RsvpStatus status) {
    final updated = member.copyWith(rsvpStatus: status);
    ref.read(memberRepositoryProvider).updateMember(updated);
  }

  Color _getCategoryColor(String? cat) {
    if (cat == 'VIP') return Colors.purple;
    if (cat == 'Family') return Colors.orange;
    if (cat == 'Friends') return Colors.blue;
    return Colors.grey;
  }

  Widget _buildRsvpChip(RsvpStatus status) {
    Color color;
    switch (status) {
      case RsvpStatus.attending: color = Colors.green; break;
      case RsvpStatus.declined: color = Colors.red; break;
      case RsvpStatus.maybe: color = Colors.amber; break;
      default: color = Colors.grey;
    }
    return Chip(
      label: Text(status.displayName.toUpperCase(), 
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      backgroundColor: color.withAlpha(20),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref, List<String> categories) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final identifierController = TextEditingController();
    String? selectedCategory = categories.isNotEmpty ? categories.first : null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Representative / Guest'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name'))),
                  IconButton(
                    icon: const Icon(Icons.contact_phone_outlined, color: Colors.blue),
                    onPressed: () => _pickFromContacts(context, nameController, phoneController, setDialogState),
                  ),
                ],
              ),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
              TextField(controller: identifierController, decoration: const InputDecoration(labelText: 'ID / Flat (Optional)')),
              if (categories.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategory = val),
                  decoration: const InputDecoration(labelText: 'Guest Category'),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isSubmitting ? null : () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter at least one name')));
                  return;
                }

                setDialogState(() => _isSubmitting = true);
                
                try {
                  final String rawNames = nameController.text.trim();
                  // Support bulk add via commas or newlines
                  final List<String> names = rawNames.split(RegExp(r'[,\n]')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
                  
                  final memberRepo = ref.read(memberRepositoryProvider);
                  final uuid = const Uuid();

                  for (final name in names) {
                    final newMember = MemberModel(
                      id: uuid.v4(),
                      eventId: widget.eventId,
                      name: name,
                      phone: names.length == 1 ? phoneController.text.trim() : '',
                      identifier: names.length == 1 ? identifierController.text.trim() : '',
                      status: MemberStatus.invited,
                      joinedAt: DateTime.now(),
                      guestCategory: selectedCategory,
                    );
                    await memberRepo.addMember(newMember);
                  }

                  if (context.mounted) {
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Successfully added ${names.length} attendee(s)')),
                     );
                  }
                } catch (e) {
                   if (context.mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Error adding attendees: $e')),
                     );
                   }
                } finally {
                   if (context.mounted) setDialogState(() => _isSubmitting = false);
                }
              },
              child: _isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactPickerListDialog extends StatefulWidget {
  const _ContactPickerListDialog();

  @override
  State<_ContactPickerListDialog> createState() => _ContactPickerListDialogState();
}

class _ContactPickerListDialogState extends State<_ContactPickerListDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Contact'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Contact>>(
                future: FastContacts.getAllContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  final contacts = snapshot.data ?? [];
                  final filtered = contacts.where((c) => 
                    c.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    c.phones.any((p) => p.number.contains(_searchQuery))
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No contacts found'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final contact = filtered[index];
                      final displayName = contact.displayName.isNotEmpty ? contact.displayName : 'Unnamed';
                      return ListTile(
                        leading: CircleAvatar(child: Text(displayName.isNotEmpty ? displayName[0] : '?')),
                        title: Text(displayName),
                        subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : 'No phone'),
                        onTap: () => Navigator.pop(context, contact),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
      ],
    );
  }
}
