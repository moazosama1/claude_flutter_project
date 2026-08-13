import '../../../domain/entities/commitment_entity.dart';

sealed class CommitmentsEvents {}

class LoadCommitmentsEvent extends CommitmentsEvents {}

class SubmitCommitmentEvent extends CommitmentsEvents {
  final CommitmentEntity commitment;
  SubmitCommitmentEvent(this.commitment);
}

class DeleteCommitmentEvent extends CommitmentsEvents {
  final int id;
  DeleteCommitmentEvent(this.id);
}

class PayCommitmentEvent extends CommitmentsEvents {
  final CommitmentEntity commitment;
  PayCommitmentEvent(this.commitment);
}
