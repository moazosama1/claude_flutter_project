import 'package:injectable/injectable.dart';

import '../../data/data_source/commitments_local_data_source.dart';
import '../../local/models/commitment_object.dart';
// objectbox.g.dart re-exports Store/Box.
import '../../objectbox.g.dart';

@Injectable(as: CommitmentsLocalDataSource)
class CommitmentsLocalDataSourceImpl implements CommitmentsLocalDataSource {
  final Store _store;
  late final Box<CommitmentObject> _box = _store.box<CommitmentObject>();

  CommitmentsLocalDataSourceImpl(this._store);

  @override
  List<CommitmentObject> getAll() => _box.getAll();

  @override
  CommitmentObject put(CommitmentObject obj) {
    _box.put(obj); // put() upserts by id; assigns a new id when id == 0.
    return obj;
  }

  @override
  void remove(int id) => _box.remove(id);

  @override
  CommitmentObject markPaid(int id, DateTime paidAt) {
    final existing = _box.get(id);
    if (existing == null) {
      throw StateError('Commitment $id not found');
    }
    existing.lastPaidDate = paidAt;
    _box.put(existing);
    return existing;
  }
}
