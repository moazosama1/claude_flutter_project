import '../../local/models/commitment_object.dart';

abstract class CommitmentsLocalDataSource {
  List<CommitmentObject> getAll();

  CommitmentObject put(CommitmentObject obj);

  void remove(int id);

  /// Reads the row, updates its lastPaidDate, and writes it back. Returns
  /// the updated object. Throws if the row doesn't exist.
  CommitmentObject markPaid(int id, DateTime paidAt);
}
