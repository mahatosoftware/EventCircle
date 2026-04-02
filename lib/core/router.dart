import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/create_event_screen.dart';
import '../presentation/screens/event_dashboard_screen.dart';
import '../presentation/screens/members_screen.dart';
import '../presentation/screens/payments_screen.dart';
import '../presentation/screens/expenses_screen.dart';
import '../presentation/screens/public_dashboard_screen.dart';
import '../presentation/screens/profile_screen.dart';

import '../presentation/screens/tasks_screen.dart';
import '../presentation/screens/create_template_screen.dart';
import '../presentation/screens/finance_settings_screen.dart';
import '../presentation/screens/timeline_screen.dart';
import '../presentation/screens/vendors_screen.dart';
import '../presentation/screens/inventory_screen.dart';
import '../presentation/screens/venues_screen.dart';
import '../presentation/screens/ticketing_screen.dart';
import '../presentation/screens/custom_fields_screen.dart';
import '../presentation/screens/announcements_screen.dart';
import '../presentation/screens/chat_screen.dart';
import '../presentation/screens/roles_screen.dart';
import '../presentation/screens/event_users_screen.dart';
import '../presentation/screens/audit_log_screen.dart';
import '../presentation/widgets/app_footer.dart';

import '../providers/auth_provider.dart';
import '../data/models/event_model.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  // This class helps GoRouter re-trigger redirect on auth changes
  final listenable = AuthRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: listenable,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';
      
      // If authState is loading, stay on splash
      if (authState.isLoading) return isSplash ? null : '/';
      
      final loggedIn = authState.value != null;

      if (!loggedIn) {
        // If not logged in and not on login page, go to login (unless it's public)
        if (!loggingIn && !state.matchedLocation.startsWith('/public')) {
          return '/login';
        }
      } else {
        // If logged in and on login or splash page, go to home
        if (loggingIn || isSplash) {
          return '/home';
        }
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const AppFooter(),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/create-event',
            builder: (context, state) => const CreateEventScreen(),
          ),
          GoRoute(
            path: '/create-template',
            builder: (context, state) {
              final title = state.uri.queryParameters['title'];
              final description = state.uri.queryParameters['description'];
              return CreateTemplateScreen(
                initialTitle: title,
                initialDescription: description,
              );
            },
          ),
          GoRoute(
            path: '/event/:eventId/save-template',
            builder: (context, state) {
               final eventId = state.pathParameters['eventId']!;
               return CreateTemplateScreen(fromEventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              final extra = state.extra;
              final initialEvent = extra is EventModel ? extra : null;
              return EventDashboardScreen(eventId: eventId, initialEvent: initialEvent);
            },
          ),
          GoRoute(
            path: '/event/:eventId/members',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return MembersScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/payments',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return PaymentsScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/expenses',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return ExpensesScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/audit-logs',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return AuditLogScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/tasks',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return TasksScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/finance-settings',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return FinanceSettingsScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/timeline',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return TimelineScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/vendors',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return VendorsScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/inventory',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return InventoryScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/venues',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return VenuesScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/ticketing',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return TicketingScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/custom-fields',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return CustomFieldsScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/announcements',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return AnnouncementsScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/chat',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return ChatScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/roles',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return RolesScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/event/:eventId/users',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return EventUsersScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/public/:eventId',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return PublicDashboardScreen(eventId: eventId);
            },
          ),
        ],
      ),
    ],
  );
});
