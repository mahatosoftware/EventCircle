import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/guest_invitation_provider.dart';
import '../../providers/venue_ticketing_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/invitation_config_model.dart';
import '../../data/models/template_model.dart';

class InvitationEditorScreen extends ConsumerStatefulWidget {
  final String eventId;
  const InvitationEditorScreen({super.key, required this.eventId});

  @override
  ConsumerState<InvitationEditorScreen> createState() => _InvitationEditorScreenState();
}

class _InvitationEditorScreenState extends ConsumerState<InvitationEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _messageController;
  late TextEditingController _venueNameController;
  late TextEditingController _venueAddressController;
  late TextEditingController _mapLinkController;
  
  String _selectedTemplate = 'Wedding';
  List<CustomQuestionModel> _questions = [];
  bool _isPublic = true;
  bool _requireOtp = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
    _venueNameController = TextEditingController();
    _venueAddressController = TextEditingController();
    _mapLinkController = TextEditingController();

    // Load existing config if available
    Future.microtask(() async {
      final config = await ref.read(guestInvitationRepositoryProvider).getInvitationConfig(widget.eventId);
      if (config != null && mounted) {
        setState(() {
          _titleController.text = config.title ?? '';
          _messageController.text = config.message ?? '';
          _venueNameController.text = config.venueName ?? '';
          _venueAddressController.text = config.venueAddress ?? '';
          _mapLinkController.text = config.mapLink ?? '';
          _selectedTemplate = config.templateType;
          _questions = List.from(config.customQuestions);
          _isPublic = config.isPublic;
          _requireOtp = config.requireOtp;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _venueNameController.dispose();
    _venueAddressController.dispose();
    _mapLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    final isLocationEnabled = eventAsync.maybeWhen(
      data: (e) {
        final snapshot = e?.templateSnapshot;
        if (snapshot == null) return true;
        final modules = snapshot?['enabledModules'] as List? ?? [];
        return modules.contains('location');
      },
      orElse: () => true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Design Invitation', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isLocationEnabled) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tip: Enable the Location module to manage venue blueprints and auto-fill these details.',
                          style: TextStyle(color: Colors.blue.shade800, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              _buildSectionTitle('Invitation Style'),
              _buildTemplatePicker(primaryColor),
              const SizedBox(height: 32),
              _buildSectionTitle('Invitation Content'),
              _buildTextField('Invitation Title', _titleController, 'e.g. Save the Date'),
              _buildTextField('Personal Message', _messageController, 'A warm welcome for your guests', maxLines: 3),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Venue & Location'),
                  if (isLocationEnabled)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextButton.icon(
                        onPressed: () => _pickVenueFromLocation(context, ref),
                        icon: const Icon(Icons.list_alt, size: 16),
                        label: const Text('Pick from Location', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              if (isLocationEnabled)
                 Align(
                   alignment: Alignment.centerRight,
                   child: Padding(
                     padding: const EdgeInsets.only(bottom: 16),
                     child: TextButton.icon(
                       onPressed: () => context.push('/event/${widget.eventId}/venues'),
                       icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                       label: const Text('Manage Locations', style: TextStyle(fontSize: 12)),
                     ),
                   ),
                 ),
              _buildTextField('Venue Name', _venueNameController, 'e.g. Grand Plaza Hotel'),
              _buildTextField('Full Address', _venueAddressController, 'Official address for navigation'),
              _buildTextField('Google Maps Link', _mapLinkController, 'Paste the map URL'),
              const SizedBox(height: 32),
              _buildSectionTitle('Custom RSVP Questions'),
              _buildQuestionsEditor(primaryColor),
              const SizedBox(height: 32),
              _buildSectionTitle('Privacy Settings'),
              _buildSwitchTile('Public Enrollment', 'Allow anyone with the link to RSVP', _isPublic, (val) => setState(() => _isPublic = val)),
              _buildSwitchTile('Security Check', 'Require OTP for guest verification', _requireOtp, (val) => setState(() => _requireOtp = val)),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomBar(primaryColor),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(color: Colors.grey.shade900, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.5)),
    );
  }

  Widget _buildTemplatePicker(Color primaryColor) {
    final templates = ['Wedding', 'Birthday', 'Corporate', 'Festival', 'Custom'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: templates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final t = templates[index];
          final isSelected = _selectedTemplate == t;
          return GestureDetector(
            onTap: () => setState(() => _selectedTemplate = t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                t,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsEditor(Color primaryColor) {
    return Column(
      children: [
        if (_questions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: const Center(child: Text('Add questions to gather more guest info', style: TextStyle(color: Colors.grey, fontSize: 13))),
          ),
        ..._questions.asMap().entries.map((entry) {
          final idx = entry.key;
          final q = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListTile(
              leading: Icon(Icons.help_outline, color: primaryColor, size: 20),
              title: Text(q.question, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(q.type.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 10, letterSpacing: 0.5)),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                onPressed: () => setState(() => _questions.removeAt(idx)),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showAddQuestionDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Custom Question'),
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: BorderSide(color: primaryColor.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildBottomBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _saveConfig,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Save & Update Invitation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  void _showAddQuestionDialog() {
    final qController = TextEditingController();
    String type = 'text';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: const Text('New Custom Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What would you like to ask?', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: qController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Do you have any allergies?',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Response Type', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: type,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'text', child: Text('Short Text')),
                          DropdownMenuItem(value: 'dropdown', child: Text('Multiple Choice')),
                          DropdownMenuItem(value: 'checkbox', child: Text('Yes/No Check')),
                        ],
                        onChanged: (val) => setDialogState(() => type = val!),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (qController.text.isNotEmpty) {
                      setState(() {
                        _questions.add(CustomQuestionModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          question: qController.text,
                          type: type,
                        ));
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveConfig() async {
    final config = InvitationConfigModel(
      eventId: widget.eventId,
      templateType: _selectedTemplate,
      title: _titleController.text,
      message: _messageController.text,
      venueName: _venueNameController.text,
      venueAddress: _venueAddressController.text,
      mapLink: _mapLinkController.text,
      customQuestions: _questions,
      isPublic: _isPublic,
      requireOtp: _requireOtp,
    );

    await ref.read(invitationActionProvider.notifier).saveConfig(config);
    if (mounted) context.pop();
  }

  Future<void> _pickVenueFromLocation(BuildContext context, WidgetRef ref) async {
    try {
      final venues = await ref.read(venueTicketingRepositoryProvider).getVenues(widget.eventId).first;
      if (!mounted) return;
      
      if (venues.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No locations found in Location module')),
        );
        return;
      }

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Venue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    final v = venues[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(Icons.location_on, color: Colors.blue, size: 20),
                      ),
                      title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(v.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: v.isMainVenue ? const Icon(Icons.star, color: Colors.amber, size: 18) : null,
                      onTap: () {
                        setState(() {
                          _venueNameController.text = v.name;
                          _venueAddressController.text = v.address;
                          _mapLinkController.text = v.mapLink ?? '';
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
