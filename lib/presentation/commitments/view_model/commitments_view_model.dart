import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/entities/commitment_entity.dart';
import '../../../domain/use_cases/add/set_commitment_use_case.dart';
import '../../../domain/use_cases/core/pay_commitment_use_case.dart';
import '../../../domain/use_cases/delete/delete_commitment_use_case.dart';
import '../../../domain/use_cases/get/get_commitments_use_case.dart';
import 'commitments_events.dart';
import 'commitments_state.dart';

@lazySingleton
class CommitmentsViewModel extends Cubit<CommitmentsState> {
  final GetCommitmentsUseCase _getCommitments;
  final SetCommitmentUseCase _setCommitment;
  final DeleteCommitmentUseCase _deleteCommitment;
  final PayCommitmentUseCase _payCommitment;

  CommitmentsViewModel(
    this._getCommitments,
    this._setCommitment,
    this._deleteCommitment,
    this._payCommitment,
  ) : super(CommitmentsState()) {
    _init();
  }

  void doIntent(CommitmentsEvents event) {
    switch (event) {
      case LoadCommitmentsEvent():
        _load();
      case SubmitCommitmentEvent():
        _submit(event.commitment);
      case DeleteCommitmentEvent():
        _delete(event.id);
      case PayCommitmentEvent():
        _pay(event.commitment);
    }
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(commitments: BaseState.loading()));
    final result = await _getCommitments();
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(commitments: BaseState.success(data)));
      case DataError(:final message):
        emit(state.copyWith(commitments: BaseState.error(message)));
    }
  }

  Future<void> _submit(CommitmentEntity commitment) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _setCommitment(commitment);
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(mutation: BaseState.success(data)));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _delete(int id) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _deleteCommitment(id);
    switch (result) {
      case DataSuccess():
        // Sentinel id == 0 tells the view this was a delete.
        emit(state.copyWith(
          mutation: BaseState.success(
            CommitmentEntity(
              id: 0,
              name: '_deleted_',
              kind: CommitmentKind.rent,
              amount: 1,
              frequency: CommitmentFrequency.monthly,
              startDate: DateTime.now(),
              categoryId: 0,
            ),
          ),
        ));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _pay(CommitmentEntity commitment) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _payCommitment(commitment);
    switch (result) {
      case DataSuccess():
        // Re-emit the commitment (with id > 0) as the mutation success so the
        // view listener knows this was a "paid" flow and shows the right toast.
        emit(state.copyWith(mutation: BaseState.success(commitment)));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }
}
