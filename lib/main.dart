import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Object? firebaseInitError;
  try {
    await Firebase.initializeApp();
  } catch (e) {
    firebaseInitError = e;
  }

  runApp(
    ProviderScope(
      child: EventCircleApp(firebaseInitError: firebaseInitError),
    ),
  );
}

class EventCircleApp extends ConsumerWidget {
  final Object? firebaseInitError;
  const EventCircleApp({super.key, required this.firebaseInitError});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (firebaseInitError != null) {
      return MaterialApp(
        title: 'Event Circle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: _FirebaseInitErrorScreen(error: firebaseInitError!),
      );
    }

    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'EventCircle',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _FirebaseInitErrorScreen extends StatelessWidget {
  final Object error;
  const _FirebaseInitErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event Circle', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Firebase is not initialized, so the app cannot run on this platform.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'If this happens on Chrome/Web, configure Firebase for Web (FlutterFire) and update initialization to pass FirebaseOptions.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              Text('Error:', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
