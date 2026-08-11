sealed class DataResult<T> {}

class DataSuccess<T> extends DataResult<T> {
  final T data;

  DataSuccess(this.data);
}

class DataError<T> extends DataResult<T> {
  final Object error;
  final String message;

  DataError(this.error) : message = error.toString();
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
