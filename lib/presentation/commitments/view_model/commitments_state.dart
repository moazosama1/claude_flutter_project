import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';
import '../../../domain/entities/commitment_entity.dart';
import 'commitment_due_status.dart';

class CommitmentsState extends Equatable {
  final BaseState<List<CommitmentEntity>> commitments;

  /// Success carries the affected commitment (id > 0), or `.empty()`-style
  /// (id == 0) after a delete, mirroring the pattern used by budgets/categories.
  final BaseState<CommitmentEntity> mutation;

  CommitmentsState({
    BaseState<List<CommitmentEntity>>? commitments,
    BaseState<CommitmentEntity>? mutation,
  })  : commitments = commitments ?? BaseState(),
        mutation = mutation ?? BaseState();

  CommitmentsState copyWith({
    BaseState<List<CommitmentEntity>>? commitments,
    BaseState<CommitmentEntity>? mutation,
  }) {
    return CommitmentsState(
      commitments: commitments ?? this.commitments,
      mutation: mutation ?? this.mutation,
    );
  }

  /// All commitments with their computed due status, ordered
  /// overdue → dueSoon → upcoming → ended.
  List<CommitmentDue> get dueList {
    final list = commitments.data ?? const [];
    final now = DateTime.now();
    final rows = list.map((c) => computeCommitmentDue(c, now)).toList();
    rows.sort((a, b) {
      final byStatus = a.status.index.compareTo(b.status.index);
      if (byStatus != 0) return byStatus;
      return a.nextDueDate.compareTo(b.nextDueDate);
    });
    return rows;
  }

  int get dueThisWeekCount => dueList
      .where(
        (r) =>
            r.status == CommitmentDueStatus.overdue ||
            r.status == CommitmentDueStatus.dueSoon,
      )
      .length;

  @override
  List<Object?> get props => [commitments, mutation];
}
