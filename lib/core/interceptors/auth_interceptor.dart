import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/const_keys.dart';
import '../constants/end_points.dart';
import '../core_cubit/core_cubit.dart';
import '../core_cubit/core_events.dart';
import '../manager/secure_storage_manager.dart';
import '../utils/auth_expired_exception.dart';

/// A [QueuedInterceptor] that handles JWT token lifecycle:
///
/// - **onRequest**: Attaches the latest `accessToken` from SecureStorage.
/// - **onError (401)**: Attempts to refresh the token via Supabase GoTrue.
///   - On success: saves new tokens, retries the original request.
///   - On failure: triggers logout and rejects with [AuthExpiredException].
///
/// Using [QueuedInterceptor] ensures that if multiple requests fail with 401
/// simultaneously, only ONE refresh attempt is made. The others queue up
/// and retry with the new token automatically.
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageManager _storageManager;

  // Note: `_retryRequest` and `_refreshToken` build their own Dio instances
  // internally to avoid interceptor loops, so we do not need to hold a
  // reference to the outer Dio here.
  AuthInterceptor(this._storageManager);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Always attach the apikey header
    options.headers['apikey'] = ConstKeys.supabaseAnonKey;

    // Skip auth header for login/register/refresh (they handle their own auth)
    final isAuthEndpoint = options.path.contains('/auth/');
    if (!isAuthEndpoint) {
      final token = await _storageManager.getString(key: ConstKeys.kUserToken);
      if (token?.isNotEmpty ?? false) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Don't try to refresh if the refresh call itself failed
    if (err.requestOptions.path.contains(EndPoints.authRefresh)) {
      log('[AuthInterceptor] Refresh token request failed — logging out');
      _triggerLogout();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthExpiredException('Refresh token expired'),
          type: DioExceptionType.unknown,
        ),
      );
    }

    // Extract the token used in the failed request
    final requestToken = err.requestOptions.headers['Authorization']
        ?.toString()
        .replaceFirst('Bearer ', '');

    // Fetch the latest token from storage
    final currentToken = await _storageManager.getString(
      key: ConstKeys.kUserToken,
    );

    // If the token in storage is already different from the one used in this request,
    // it means another concurrent request has already refreshed the token.
    // We can directly retry this request with the refreshed token.
    if (currentToken != null && currentToken.isNotEmpty && currentToken != requestToken) {
      log(
        '[AuthInterceptor] Token was already refreshed by another request — retrying with new token',
      );

      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $currentToken';

      try {
        final response = await _retryRequest(retryOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
            type: DioExceptionType.unknown,
          ),
        );
      }
    }

    // Otherwise, we are the first request to fail with 401, so we must refresh the token.
    try {
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry the original request with the new token
        final newToken = await _storageManager.getString(
          key: ConstKeys.kUserToken,
        );

        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newToken';

        log(
          '[AuthInterceptor] Token refreshed successfully — retrying ${retryOptions.method} ${retryOptions.path}',
        );

        final response = await _retryRequest(retryOptions);
        return handler.resolve(response);
      } else {
        log('[AuthInterceptor] Token refresh failed — logging out');
        _triggerLogout();
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: const AuthExpiredException('Token refresh failed'),
            type: DioExceptionType.unknown,
          ),
        );
      }
    } catch (e) {
      log('[AuthInterceptor] Exception during refresh: $e — logging out');
      _triggerLogout();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const AuthExpiredException('Token refresh exception'),
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  /// Retries a request using a separate clean Dio instance.
  /// This prevents deadlocks inside [QueuedInterceptor] since the retry request
  /// bypasses the queued execution of this interceptor.
  Future<Response> _retryRequest(RequestOptions requestOptions) {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: requestOptions.validateStatus,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );

    final retryDio = Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: requestOptions.connectTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
      ),
    );

    if (kDebugMode) {
      retryDio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return retryDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Calls Supabase GoTrue `/auth/v1/token?grant_type=refresh_token`
  /// Returns `true` if successful and tokens are updated.
  Future<bool> _refreshToken() async {
    final refreshToken = await _storageManager.getString(
      key: ConstKeys.kRefreshToken,
    );

    if (refreshToken == null || refreshToken.isEmpty) {
      log('[AuthInterceptor] No refresh token available');
      return false;
    }

    try {
      log('[AuthInterceptor] Attempting token refresh...');

      // Use a separate Dio instance to avoid interceptor loops
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          receiveDataWhenStatusError: true,
          receiveTimeout: const Duration(seconds: 10),
          connectTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await refreshDio.post(
        EndPoints.authRefresh,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            'apikey': ConstKeys.supabaseAnonKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await _storageManager.setString(
            key: ConstKeys.kUserToken,
            value: newAccessToken,
          );

          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _storageManager.setString(
              key: ConstKeys.kRefreshToken,
              value: newRefreshToken,
            );
          }

          log('[AuthInterceptor] Token refresh successful');
          return true;
        }
      }

      log(
        '[AuthInterceptor] Token refresh returned unexpected response: ${response.statusCode}',
      );
      return false;
    } catch (e) {
      log('[AuthInterceptor] Token refresh HTTP error: $e');
      return false;
    }
  }

  /// Triggers logout via CoreCubit (lazySingleton from get_it)
  void _triggerLogout() {
    try {
      GetIt.instance<CoreCubit>().doIntent(LogoutCoreEvent());
    } catch (e) {
      log('[AuthInterceptor] Failed to trigger logout: $e');
    }
  }
}
