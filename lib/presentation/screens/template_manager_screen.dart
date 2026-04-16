import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/template_sync_provider.dart';
import '../../data/system_templates/system_template_models.dart';
import '../../data/models/template_model.dart';

class TemplateManagerScreen extends ConsumerStatefulWidget {
  const TemplateManagerScreen({super.key});

  @override
  ConsumerState<TemplateManagerScreen> createState() => _TemplateManagerScreenState();
}

class _TemplateManagerScreenState extends ConsumerState<TemplateManagerScreen> {
  bool _isSyncing = false;
  String? _statusMessage;
  SystemTemplatePack? _pack;
  Map<String, TemplateModel?> _remoteTemplates = {};
  int _installedVersion = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final source = ref.read(systemTemplateSourceProvider);
    final dao = ref.read(templateFirestoreDaoProvider);
    final versionManager = ref.read(templateVersionManagerProvider);

    final pack = await source.loadPack();
    final installed = await versionManager.getInstalledVersion();

    if (pack != null) {
      final remotes = <String, TemplateModel?>{};
      for (final templateDef in pack.templates) {
        remotes[templateDef.templateId] = await dao.getTemplateById(templateDef.templateId);
      }
      if (mounted) {
        setState(() {
          _pack = pack;
          _installedVersion = installed;
          _remoteTemplates = remotes;
        });
      }
    }
  }

  Future<void> _sync() async {
    setState(() {
      _isSyncing = true;
      _statusMessage = 'Starting sync...';
    });

    try {
      final syncService = ref.read(templateSyncServiceProvider);
      await syncService.syncTemplates(
        force: true,
        onProgress: (current, total) {
          if (mounted) {
            setState(() {
              _statusMessage = 'Syncing $current of $total templates...';
            });
          }
        },
      );
      await _loadData();
      setState(() {
        _statusMessage = 'Sync completed successfully!';
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = 'Sync failed: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Manager'),
      ),
      body: userAsync.when(
        data: (user) {
          const allowedEmails = ['mahatosoftware@gmail.com', 'debasishmahato@gmail.com'];
          if (user == null || !allowedEmails.contains(user.email)) {
            return const Center(child: Text('Access Denied'));
          }

          if (_pack == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 12),
                          Text('System Template Sync', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Asset Pack Version', _pack!.version.toString()),
                      _buildInfoRow('Local Recorded Version', _installedVersion.toString()),
                      const Divider(height: 32),
                      if (_statusMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _statusMessage!.contains('failed') ? Colors.red.withAlpha(25) : Colors.green.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _statusMessage!.contains('failed') ? Colors.red.withAlpha(50) : Colors.green.withAlpha(50)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _statusMessage!.contains('failed') ? Icons.error_outline : Icons.check_circle_outline,
                                color: _statusMessage!.contains('failed') ? Colors.red : Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _statusMessage!,
                                  style: TextStyle(
                                    color: _statusMessage!.contains('failed') ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isSyncing ? null : _sync,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: _isSyncing 
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.sync),
                          label: Text(_isSyncing ? 'Syncing...' : 'Force Sync All Templates'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Templates in Pack', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('${_pack!.templates.length} Total', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ..._pack!.templates.map((def) {
                final remote = _remoteTemplates[def.templateId];
                final needsUpdate = remote == null || remote.version < def.version;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (needsUpdate ? Colors.orange : Colors.green).withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        needsUpdate ? Icons.system_update_alt : Icons.check,
                        color: needsUpdate ? Colors.orange : Colors.green,
                        size: 20,
                      ),
                    ),
                    title: Text(def.templateName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('ID: ${def.templateId}', style: const TextStyle(fontSize: 12)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildVersionRow('Asset Version', def.version, Colors.blue),
                            const SizedBox(height: 8),
                            _buildVersionRow('Firestore Version', remote?.version ?? 0, remote == null ? Colors.red : Colors.green),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Blueprint Content:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildCountTag('Roles', def.roleBlueprints.length, Icons.badge_outlined),
                                _buildCountTag('Tasks', def.taskBlueprints.length, Icons.check_circle_outline),
                                _buildCountTag('Timeline', def.timelineBlueprints.length, Icons.schedule_outlined),
                                _buildCountTag('Budget', def.budgetBlueprints.length, Icons.receipt_long_outlined),
                                _buildCountTag('Vendors', def.vendorBlueprints.length, Icons.storefront_outlined),
                                _buildCountTag('Inventory', def.inventoryBlueprints.length, Icons.inventory_2_outlined),
                              ],
                            ),
                            if (needsUpdate)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(
                                      remote == null ? 'Missing in Firestore' : 'Newer version available in assets',
                                      style: const TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildVersionRow(String label, int version, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(50)),
          ),
          child: Text(
            'v$version',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCountTag(String label, int count, IconData icon) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            '$count $label',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
