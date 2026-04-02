import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/access_control_provider.dart';
import '../../data/models/task_model.dart';
import '../../data/models/event_model.dart';
import '../../data/models/event_role_model.dart';
import '../../data/services/event_template_service.dart';
import 'package:uuid/uuid.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final String eventId;
  const TasksScreen({super.key, required this.eventId});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  Future<void> _loadSuggestedTasks(EventModel event) async {
    final suggestions = EventTemplateService.getSuggestedTasks(widget.eventId, event.category);
    final repo = ref.read(taskRepositoryProvider);
    
    // Add each suggestion to the repo
    for (var task in suggestions) {
      await repo.addTask(task);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added ${suggestions.length} suggested tasks for ${event.category.displayName}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksForEventStreamProvider(widget.eventId));
    final eventAsync = ref.watch(eventByIdStreamProvider(widget.eventId));
    final canEditTasks = ref.watch(
      hasModuleAccessProvider((eventId: widget.eventId, module: EventModules.tasks, required: ModuleAccessLevel.edit)),
    );
    final canUpdateTasks = ref.watch(
      hasModuleAccessProvider((eventId: widget.eventId, module: EventModules.tasks, required: ModuleAccessLevel.update)),
    );

    return DefaultTabController(
      length: TaskPhase.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event Task Management'),
          actions: [
            eventAsync.when(
              data: (event) => IconButton(
                icon: const Icon(Icons.tips_and_updates_outlined),
                tooltip: 'Load Suggestions',
                onPressed: (event == null || !canEditTasks) ? null : () => _loadSuggestedTasks(event),
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, st) => const SizedBox.shrink(),
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            tabs: TaskPhase.values.map((phase) => Tab(text: phase.displayName)).toList(),
          ),
        ),
        body: tasksAsync.when(
          data: (tasks) {
            return TabBarView(
              children: TaskPhase.values.map((phase) {
                final phasedTasks = tasks.where((t) => t.phase == phase).toList();
                if (phasedTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist_rtl, size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No ${phase.displayName} tasks yet.', style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 24),
                        eventAsync.maybeWhen(
                          data: (event) => event != null ? ElevatedButton.icon(
                            onPressed: () => _loadSuggestedTasks(event),
                            icon: const Icon(Icons.auto_fix_high),
                            label: const Text('Load Suggested Tasks'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[50],
                              foregroundColor: Colors.blue[700],
                            ),
                          ) : const SizedBox.shrink(),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: phasedTasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskTile(context, phasedTasks[index], ref, canUpdateTasks: canUpdateTasks);
                  },
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: !canEditTasks
              ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No permission to add tasks')))
              : () => _showAddTaskDialog(context, ref),
          label: const Text('Add Task'),
          icon: const Icon(Icons.add_task),
        ),
      ),
    );
  }

  Widget _buildTaskTile(BuildContext context, TaskModel task, WidgetRef ref, {required bool canUpdateTasks}) {
    final isDone = task.status == TaskStatus.done;
    return Card(
      elevation: isDone ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDone ? BorderSide(color: Colors.grey.withAlpha(50)) : BorderSide.none,
      ),
      child: ExpansionTile(
        leading: Checkbox(
          value: isDone,
          onChanged: !canUpdateTasks
              ? null
              : (val) {
                  final updatedTask = task.copyWith(status: val! ? TaskStatus.done : TaskStatus.pending);
                  ref.read(taskRepositoryProvider).updateTask(updatedTask);
                },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Row(
          children: [
            if (task.role != null) ...[
              const Icon(Icons.person_outline, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Text(task.role!, style: const TextStyle(fontSize: 12, color: Colors.blue)),
              const SizedBox(width: 12),
            ],
            if (task.dueOffset != null) ...[
              const Icon(Icons.timer_outlined, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text(task.dueOffset!, style: const TextStyle(fontSize: 12, color: Colors.orange)),
            ],
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(task.description!, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                  const SizedBox(height: 16),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Assignee: ${task.assignedMemberName ?? 'Unassigned'}', 
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                    TextButton.icon(
                      onPressed: canUpdateTasks ? () {} : null,
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final roleController = TextEditingController();
    final dueController = TextEditingController();
    TaskPhase selectedPhase = TaskPhase.preEvent;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24, left: 24, right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task Title (e.g. Book Venue)', prefixIcon: Icon(Icons.title)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.description_outlined)),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPhase>(
                  value: selectedPhase,
                  decoration: const InputDecoration(labelText: 'Event Phase', prefixIcon: Icon(Icons.category_outlined)),
                  items: TaskPhase.values.map((p) => DropdownMenuItem(value: p, child: Text(p.displayName))).toList(),
                  onChanged: (val) => setDialogState(() => selectedPhase = val!),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: roleController,
                        decoration: const InputDecoration(labelText: 'Assigned Role', prefixIcon: Icon(Icons.person_pin_outlined)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: dueController,
                        decoration: const InputDecoration(labelText: 'Due (e.g. T-7)', prefixIcon: Icon(Icons.timer_outlined)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) return;
                    final newTask = TaskModel(
                      id: const Uuid().v4(),
                      eventId: widget.eventId,
                      title: titleController.text,
                      description: descController.text,
                      status: TaskStatus.pending,
                      phase: selectedPhase,
                      role: roleController.text,
                      dueOffset: dueController.text,
                    );
                    await ref.read(taskRepositoryProvider).addTask(newTask);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Add Task'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
