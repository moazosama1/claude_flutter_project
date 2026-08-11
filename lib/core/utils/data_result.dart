import 'error_handler.dart';

sealed class DataResult<T> {}

class DataSuccess<T> extends DataResult<T> {
  final T data;

  DataSuccess(this.data);
}

class DataError<T> extends DataResult<T> {
  final Object error;
  final String message;

  DataError(this.error) : message = ErrorHandler.extractErrorMessage(error);
}

Future<DataResult<TOut>> safeDataCall<TIn, TOut>(
  Future<TIn> Function() dataCall,
  TOut Function(TIn) transform,
) async {
  try {
    final result = await dataCall();
    return DataSuccess(transform(result));
  } catch (e) {
    return DataError(e);
  }
}

Stream<DataResult<T>> safeDataStream<T>(Stream<T> Function() streamCall) {
  try {
    return streamCall()
        .map<DataResult<T>>((data) => DataSuccess(data))
        .handleError((error) => DataError(error));
  } catch (e) {
    return Stream.value(DataError(e));
  }
}
