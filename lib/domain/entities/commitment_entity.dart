import 'package:equatable/equatable.dart';

/// The four kinds of commitments the app tracks. The kind drives which of
/// the type-specific fields on [CommitmentEntity] are meaningful for that
/// commitment (e.g. `payoutMonth` is only used by [jamia]).
enum CommitmentKind {
  /// Rent, subscriptions, memberships — fixed recurring outflow, indefinite.
  rent,

  /// Rotating savings group. Fixed contribution every period + one big
  /// payout month.
  jamia,

  /// Loan or "buy now pay later" — fixed recurring outflow for a set
  /// number of installments, then done.
  installment,

  /// Savings goal — regular contribution toward a target amount.
  goal,
}

enum CommitmentFrequency { weekly, monthly, quarterly, yearly }

class CommitmentEntity extends Equatable {
  final int id;
  final String name;
  final CommitmentKind kind;

  /// Per-payment amount. For [CommitmentKind.goal] this is the recurring
  /// contribution.
  final double amount;

  final CommitmentFrequency frequency;
  final DateTime startDate;

  /// Null = open-ended (typical for [CommitmentKind.rent]).
  final DateTime? endDate;

  /// Total number of payments for kinds that have a finite plan
  /// ([jamia], [installment]). Null for open-ended kinds.
  final int? totalInstallments;

  final int categoryId;

  /// Updated when the user marks a due payment as paid. Null = never paid,
  /// so `nextDueDate == startDate`.
  final DateTime? lastPaidDate;

  // -- Jam'iya-specific ----------------------------------------------------

  /// Which installment number (1-indexed) is the user's payout month.
  final int? payoutMonth;

  /// How much the user receives on the payout month.
  final double? payoutAmount;

  // -- Goal-specific -------------------------------------------------------

  /// Total the user wants to reach.
  final double? targetAmount;

  /// Optional deadline for the goal.
  final DateTime? targetDate;

  final String? notes;

  // Public constructor: enforces basic domain invariants that hold for every
  // kind. Kind-specific requirements (e.g. jam'iya needs payoutMonth) are
  // validated at the form/use-case layer, not here — that lets `.empty()`
  // and copy-paths stay simple.
  CommitmentEntity({
    required this.id,
    required this.name,
    required this.kind,
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.categoryId,
    this.endDate,
    this.totalInstallments,
    this.lastPaidDate,
    this.payoutMonth,
    this.payoutAmount,
    this.targetAmount,
    this.targetDate,
    this.notes,
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'must be greater than zero');
    }
    if (totalInstallments != null && totalInstallments! <= 0) {
      throw ArgumentError.value(
        totalInstallments,
        'totalInstallments',
        'must be greater than zero',
      );
    }
  }

  CommitmentEntity copyWith({
    int? id,
    String? name,
    CommitmentKind? kind,
    double? amount,
    CommitmentFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    int? totalInstallments,
    int? categoryId,
    DateTime? lastPaidDate,
    int? payoutMonth,
    double? payoutAmount,
    double? targetAmount,
    DateTime? targetDate,
    String? notes,
  }) {
    return CommitmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      categoryId: categoryId ?? this.categoryId,
      lastPaidDate: lastPaidDate ?? this.lastPaidDate,
      payoutMonth: payoutMonth ?? this.payoutMonth,
      payoutAmount: payoutAmount ?? this.payoutAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    kind,
    amount,
    frequency,
    startDate,
    endDate,
    totalInstallments,
    categoryId,
    lastPaidDate,
    payoutMonth,
    payoutAmount,
    targetAmount,
    targetDate,
    notes,
  ];
}
