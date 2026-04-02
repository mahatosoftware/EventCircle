import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/event_model.dart';
import '../data/models/member_model.dart';
import '../data/models/payment_model.dart';
import '../data/models/expense_model.dart';
import 'event_provider.dart';
import 'member_provider.dart';
import 'payment_provider.dart';
import 'expense_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_dashboard_provider.freezed.dart';

@freezed
class PublicDashboardData with _$PublicDashboardData {
  const factory PublicDashboardData({
    required EventModel event,
    required List<MemberModel> members,
    required List<PaymentModel> payments,
    required List<ExpenseModel> expenses,
    required double totalCollected,
    required double totalExpenses,
    required Map<String, PaymentModel> memberPaymentMap,
  }) = _PublicDashboardData;
}

final publicDashboardDataProvider = Provider.family<AsyncValue<PublicDashboardData>, String>((ref, eventId) {
  final eventAsync = ref.watch(eventByIdStreamProvider(eventId));
  final membersAsync = ref.watch(membersForEventStreamProvider(eventId));
  final paymentsAsync = ref.watch(paymentsForEventStreamProvider(eventId));
  final expensesAsync = ref.watch(expensesForEventStreamProvider(eventId));

  if (eventAsync.hasError) return AsyncError(eventAsync.error!, eventAsync.stackTrace!);
  
  final event = eventAsync.value;
  if (event == null) return const AsyncLoading();

  final members = membersAsync.value ?? [];
  final payments = paymentsAsync.value ?? [];
  final expenses = expensesAsync.value ?? [];

  double totalCollected = 0;
  final memberPaymentMap = <String, PaymentModel>{};
  for (final p in payments) {
    if (p.status == PaymentStatus.success) {
      totalCollected += p.amount;
      // Keep the latest successful payment per member for dashboard status
      final existing = memberPaymentMap[p.memberId];
      if (existing == null || p.timestamp.isAfter(existing.timestamp)) {
        memberPaymentMap[p.memberId] = p;
      }
    }
  }

  double totalSpent = 0;
  for (final e in expenses) {
    totalSpent += e.amount;
  }

  return AsyncData(PublicDashboardData(
    event: event,
    members: members,
    payments: payments,
    expenses: expenses,
    totalCollected: totalCollected,
    totalExpenses: totalSpent,
    memberPaymentMap: memberPaymentMap,
  ));
});
