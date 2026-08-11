import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/end_points.dart';
import '../interceptors/auth_interceptor.dart';
import '../manager/secure_storage_manager.dart';
import '../../api/client/api_client.dart';

@module
abstract class AppModules {
  @lazySingleton
  ApiClient provideApiClient(Dio dio) => ApiClient(dio);

  @preResolve
  @lazySingleton
  Future<Dio> provideDio(SecureStorageManager storageManager) async {
    final dio = Dio(provideBaseOptions(EndPoints.baseUrl));
    dio.interceptors.addAll([
      providePrettyDioLogger,
      AuthInterceptor(storageManager, dio),
    ]);
    return dio;
  }

  @lazySingleton
  FlutterSecureStorage get provideSecureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @lazySingleton
  Connectivity get provideConnectivity => Connectivity();

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
