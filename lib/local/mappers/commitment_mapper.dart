import '../../domain/entities/commitment_entity.dart';
import '../models/commitment_object.dart';

extension CommitmentObjectX on CommitmentObject {
  CommitmentEntity toEntity() => CommitmentEntity(
    id: id,
    name: name,
    kind: CommitmentKind.values[kindIndex],
    amount: amount,
    frequency: CommitmentFrequency.values[frequencyIndex],
    startDate: startDate,
    endDate: endDate,
    totalInstallments: totalInstallments,
    categoryId: categoryId,
    lastPaidDate: lastPaidDate,
    payoutMonth: payoutMonth,
    payoutAmount: payoutAmount,
    targetAmount: targetAmount,
    targetDate: targetDate,
    notes: notes,
  );
}

extension CommitmentEntityX on CommitmentEntity {
  CommitmentObject toObject() => CommitmentObject(
    id: id,
    name: name,
    kindIndex: kind.index,
    amount: amount,
    frequencyIndex: frequency.index,
    startDate: startDate,
    endDate: endDate,
    totalInstallments: totalInstallments,
    categoryId: categoryId,
    lastPaidDate: lastPaidDate,
    payoutMonth: payoutMonth,
    payoutAmount: payoutAmount,
    targetAmount: targetAmount,
    targetDate: targetDate,
    notes: notes,
  );
}
