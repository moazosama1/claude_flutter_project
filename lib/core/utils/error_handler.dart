import 'package:dio/dio.dart';

class ErrorHandler {
  static String extractErrorMessage(Object error) {
    if (error is DioException) {
      if (error.response?.data is Map) {
        final data = error.response!.data as Map;
        // Try common error keys from various API response formats
        return data['error']?.toString() ??
            data['message']?.toString() ??
            data['msg']?.toString() ??
            data['error_description']?.toString() ??
            error.message ??
            error.toString();
      }
      return error.message ?? error.toString();
    }
    return error.toString();
  }
}
