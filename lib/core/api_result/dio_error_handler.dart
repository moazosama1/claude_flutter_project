import 'package:dio/dio.dart';
import 'package:initialize_project/generated/l10n.dart';

String handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return AppLocalizations().connectionTimeout;

    case DioExceptionType.sendTimeout:
      return AppLocalizations().sendTimeout;

    case DioExceptionType.receiveTimeout:
      return AppLocalizations().receiveTimeout;

    case DioExceptionType.badCertificate:
      return AppLocalizations().badCertificate;

    case DioExceptionType.badResponse:
      return _extractErrorMessageFromResponse(error.response);

    case DioExceptionType.cancel:
      return AppLocalizations().dioErrorCancel;

    case DioExceptionType.connectionError:
      return AppLocalizations().connectionError;

    case DioExceptionType.unknown:
      return "${AppLocalizations().unknownError} ${error.message ?? AppLocalizations().unknown}";
    case DioExceptionType.transformTimeout:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}

String _extractErrorMessageFromResponse(Response? response) {
  if (response == null) return AppLocalizations().noResponse;

  try {
    final data = response.data;
    if (data is Map) {
      if (data.containsKey('message')) return data['message'];
      if (data.containsKey('error')) return data['error'];
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return "${AppLocalizations().badResponse} [${response.statusCode}].";
  } catch (e) {
    return AppLocalizations().failedToParseResponse;
  }
}
