import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../data/models/event_model.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final String eventId;
  const EditEventScreen({super.key, required this.eventId});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _initFromEvent(EventModel event) {
    if (_initialized) return;
    _initialized = true;
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _amountController.text = event.amount.toStringAsFixed(event.amount.truncateToDouble() == event.amount ? 0 : 2);
    _locationController.text = event.location ?? '';
    _startDate = event.startDate;
    _endDate = event.endDate;
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final now = DateTime.now();
    final initial = (isStart ? _startDate : _endDate) ?? now;
    
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5),
    );

    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null) return;

    setState(() {
      final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _startDate = combined;
        // Auto-set end date to 2 hours after start if not set
        if (_endDate == null) {
          _endDate = combined.add(const Duration(hours: 2));
        }
      } else {
        _endDate = combined;
      }
    });
  }

  Future<void> _save(EventModel current) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final amountRaw = _amountController.text.trim();
    final parsedAmount = double.tryParse(amountRaw.replaceAll(',', ''));
    if (parsedAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final updated = current.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        amount: parsedAmount,
        startDate: _startDate,
        endDate: _endDate,
      );

      await ref.read(eventRepositoryProvider).updateEvent(updated);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event updated')));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update event: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));

    return eventAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: Center(child: Text('Error loading event: $e')),
      ),
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Event')),
            body: const Center(child: Text('Event not found')),
          );
        }

        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Event')),
            body: const Center(child: Text('You must be logged in')),
          );
        }

        if (event.organizerId != user.id) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Event')),
            body: const Center(child: Text('Only the organizer can edit this event.')),
          );
        }

        _initFromEvent(event);

        final dateText = (_startDate == null || _endDate == null)
            ? 'Select dates'
            : '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Event'),
            actions: [
              TextButton(
                onPressed: _isSaving ? null : () => _save(event),
                child: _isSaving
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.event),
                    ),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    maxLines: 3,
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Venue (Optional)',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDateTime(isStart: true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Starts',
                              prefixIcon: Icon(Icons.calendar_today_outlined),
                            ),
                            child: Text(
                              _startDate == null 
                                ? 'Select Start' 
                                : DateFormat('MMM dd, HH:mm').format(_startDate!),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDateTime(isStart: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Ends',
                              prefixIcon: Icon(Icons.event_available_outlined),
                            ),
                            child: Text(
                              _endDate == null 
                                ? 'Select End' 
                                : DateFormat('MMM dd, HH:mm').format(_endDate!),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (_startDate == null && _endDate == null)
                          ? null
                          : () => setState(() {
                                _startDate = null;
                                _endDate = null;
                              }),
                      child: const Text('Clear schedule'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

