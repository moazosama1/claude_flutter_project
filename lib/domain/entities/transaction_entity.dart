import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final int id;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime date;
  final DateTime createdAt;

  // Public constructor: enforces domain invariants.
  // - amount must be > 0
  // - note (if present) must be <= 200 characters
  TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.note,
  }) {
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'must be greater than zero');
    }
    if (note != null && note!.length > 200) {
      throw ArgumentError.value(
        note!.length,
        'note.length',
        'must be at most 200 characters',
      );
    }
  }

  // Private constructor: bypasses guards. Used only by [empty] so form UIs can
  // seed a zero-valued instance before the user has typed anything valid.
  const TransactionEntity._raw({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.note,
  });

  // Zero-valued instance for form initialization. amount = 0 is intentionally
  // allowed here — the form must not submit this back until the user provides
  // a positive amount (validators upstream enforce that at submit time).
  factory TransactionEntity.empty() {
    final now = DateTime.fromMillisecondsSinceEpoch(0);
    return TransactionEntity._raw(
      id: 0,
      amount: 0,
      type: TransactionType.expense,
      categoryId: 0,
      note: null,
      date: now,
      createdAt: now,
    );
  }

  // copyWith goes through the public constructor so invariants are re-checked
  // on every derived instance. If a caller needs an intentionally invalid
  // state (e.g. a form's blank baseline) they must use [empty] explicitly.
  TransactionEntity copyWith({
    int? id,
    double? amount,
    TransactionType? type,
    int? categoryId,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    categoryId,
    note,
    date,
    createdAt,
  ];
}
