import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/event_model.dart';
import '../data/models/member_model.dart';
import '../data/models/payment_model.dart';
import '../data/models/expense_model.dart';
import '../data/models/event_role_model.dart';
import 'event_provider.dart';
import 'member_provider.dart';
import 'payment_provider.dart';
import 'expense_provider.dart';
import 'access_control_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_provider.freezed.dart';

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    required EventModel event,
    required List<MemberModel> members,
    required List<PaymentModel> payments,
    required List<ExpenseModel> expenses,
    required double totalCollected,
    required double totalExpenses,
    required double totalPendingReimbursement,
    required double totalPaidReimbursement,
    required Map<String, MemberModel> memberMap,
    required List<PaymentModel> recentActivities,
    required Map<String, ModuleAccessLevel> moduleAccess,
  }) = _DashboardData;
}

final dashboardDataProvider = Provider.family<AsyncValue<DashboardData>, String>((ref, eventId) {
  final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
  final membersAsync = ref.watch(membersForEventStreamProvider(eventId));
  final paymentsAsync = ref.watch(paymentsForEventStreamProvider(eventId));
  final expensesAsync = ref.watch(expensesForEventStreamProvider(eventId));

  // If anything is still in error state and we don't have a value, return error.
  if (eventAsync.hasError) return AsyncError(eventAsync.error!, eventAsync.stackTrace!);

  // We wait for the event at minimum.
  final event = eventAsync.value;
  if (event == null) return const AsyncLoading();

  final members = membersAsync.value ?? [];
  final payments = paymentsAsync.value ?? [];
  final expenses = expensesAsync.value ?? [];

  // Pre-calculate access
  final accessMap = <String, ModuleAccessLevel>{};
  for (final moduleKey in EventModules.all) {
     accessMap[moduleKey] = ref.watch(moduleAccessForEventProvider((eventId: eventId, module: moduleKey)));
  }

  // Pre-calculate totals
  double totalCollected = 0;
  for (final p in payments) {
    if (p.status == PaymentStatus.success) {
      totalCollected += p.amount;
    }
  }

  double totalSpent = 0;
  double pendingReimbursement = 0;
  double paidReimbursement = 0;

  for (final e in expenses) {
    if (e.paidByType == PaidByType.organizer) {
       totalSpent += e.amount;
    } else if (e.isReimbursable) {
       // Volunteer-paid expenses also count as total event cost/spent immediately in accounting
       totalSpent += e.amount;
       if (e.reimbursementStatus == ReimbursementStatus.paid) {
         paidReimbursement += e.amount;
       } else if (e.reimbursementStatus != ReimbursementStatus.rejected) {
         pendingReimbursement += e.amount;
       }
    }
  }

  // Pre-map members
  final memberMap = {for (var m in members) m.id: m};

  // Sort and pick recent activities
  final sortedPayments = [...payments]
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  final recentActivities = sortedPayments.length > 5 
      ? sortedPayments.sublist(0, 5) 
      : sortedPayments;

  return AsyncData(DashboardData(
    event: event,
    members: members,
    payments: payments,
    expenses: expenses,
    totalCollected: totalCollected,
    totalExpenses: totalSpent,
    totalPendingReimbursement: pendingReimbursement,
    totalPaidReimbursement: paidReimbursement,
    memberMap: memberMap,
    recentActivities: recentActivities,
    moduleAccess: accessMap,
  ));
});
