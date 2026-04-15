import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/template_sync_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Seed / sync system templates in the background before user reaches template selection.
    try {
      final sync = ref.read(templateSyncServiceProvider);
      await sync.loadTemplatesIfNeeded().timeout(const Duration(seconds: 12));
      await sync.syncTemplates().timeout(const Duration(seconds: 12));
    } catch (e) {
      // Non-fatal: templates can still be used if already present, and network may be offline.
      debugPrint('SplashScreen: Template sync skipped/failed: $e');
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    // In a real app, check auth state
    // For now, go to login
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.blur_circular,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Event Circle',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage events with transparency',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(204),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
