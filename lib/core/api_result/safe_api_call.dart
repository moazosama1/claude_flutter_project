import 'package:initialize_project/core/api_result/api_result.dart';

Future<ApiResult<TOut>> safeApiCall<TIn, TOut>(
  Future<TIn> Function() apiCall,
  TOut Function(TIn) transform,
) async {
  try {
    final result = await apiCall();
    return ApiSuccessResult(transform(result));
  } catch (e) {
    return ApiErrorResult(e);
  }
}
