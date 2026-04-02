import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/audit_log_provider.dart';
import '../../providers/user_provider.dart';

class AuditLogScreen extends ConsumerWidget {
  final String eventId;
  const AuditLogScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsForEventStreamProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit History'),
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No audit entries found'));
          }
          return ListView.builder(
            itemCount: logs.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final log = logs[index];
              return Consumer(
                builder: (context, ref, child) {
                  final userAsync = ref.watch(userByIdProvider(log.userId));
                  final userName = userAsync.maybeWhen(
                    data: (u) => u?.name ?? 'ID: ${log.userId.substring(0, 4)}',
                    orElse: () => '...',
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getActionColor(log.action).withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  log.action.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getActionColor(log.action),
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd, HH:mm').format(log.timestamp),
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$userName ${log.action}d a ${log.entityType}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (log.newData != null) ...[
                            const Text('Details:', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            _buildDataSummary(log.newData!),
                          ],
                          if (log.reason != null) ...[
                            const SizedBox(height: 8),
                            Text('Reason: ${log.reason}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'create': return Colors.green;
      case 'update': return Colors.orange;
      case 'delete': return Colors.red;
      default: return Colors.blue;
    }
  }

  Widget _buildDataSummary(Map<String, dynamic> data) {
    final amount = data['amount'];
    final method = data['paymentMethod'];
    final ref = data['referenceNumber'];

    return Text(
      'Amount: ₹$amount • Method: ${method ?? "unknown"}${ref != null ? " • Ref: $ref" : ""}',
      style: const TextStyle(fontSize: 11),
    );
  }
}
