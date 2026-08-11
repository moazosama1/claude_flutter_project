import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../local/models/local_db_model.dart';
import '../constants/const_keys.dart';
import '../constants/end_points.dart';
import '../manager/secure_storage_manager.dart';

@module
abstract class AppModules {
  @preResolve
  @lazySingleton
  Future<Dio> provideDio(SecureStorageManager storageManager) async {
    final dio = Dio(provideBaseOptions(EndPoints.baseUrl));
    dio.interceptors.addAll([
      providePrettyDioLogger,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = await storageManager.getString(
            key: ConstKeys.kUserToken,
          );
          if (token?.isNotEmpty ?? false) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    ]);
    return dio;
  }

  @lazySingleton
  FlutterSecureStorage get provideSecureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @preResolve
  @lazySingleton
  Future<SharedPreferences> provideSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  BaseOptions provideBaseOptions(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      receiveTimeout: const Duration(seconds: 20),
      connectTimeout: const Duration(seconds: 20),
    );
  }

  PrettyDioLogger get providePrettyDioLogger => PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
    enabled: kDebugMode,
  );
}
