import 'package:objectbox/objectbox.dart';

@Entity()
class CommitmentObject {
  @Id()
  int id;

  String name;

  /// Ordinal of [CommitmentKind]; conversion happens in the mapper so the
  /// domain keeps its enum and the object keeps its int.
  int kindIndex;

  double amount;

  /// Ordinal of [CommitmentFrequency].
  int frequencyIndex;

  @Property(type: PropertyType.date)
  DateTime startDate;

  @Property(type: PropertyType.date)
  DateTime? endDate;

  int? totalInstallments;

  int categoryId;

  @Property(type: PropertyType.date)
  DateTime? lastPaidDate;

  int? payoutMonth;
  double? payoutAmount;

  double? targetAmount;
  @Property(type: PropertyType.date)
  DateTime? targetDate;

  String? notes;

  CommitmentObject({
    this.id = 0,
    required this.name,
    required this.kindIndex,
    required this.amount,
    required this.frequencyIndex,
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
  });
}
