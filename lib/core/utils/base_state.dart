import 'package:equatable/equatable.dart';

class BaseState<T> extends Equatable {
  final String? errorMessage;
  final bool isLoading;
  final T? data;
  final DateTime timestamp;

  BaseState({this.data, this.errorMessage, this.isLoading = false})
    : timestamp = DateTime.now();
  factory BaseState.loading() => BaseState(isLoading: true);
  factory BaseState.success(T data) => BaseState(data: data);
  factory BaseState.error(String errorMessage) =>
      BaseState(errorMessage: errorMessage);
  @override
  List<Object?> get props => [isLoading, errorMessage, data, timestamp];
}
