import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/api/api_config.dart';
import '../../services/storage/token_storage.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

/// Point d'entrée unique vers le backend : baseUrl, timeouts, token,
/// logs et conversion des erreurs sont gérés ici une seule fois.
/// Les services ne reçoivent que le corps de la réponse ou une
/// [ApiException].
class ApiClient {
  ApiClient(TokenStorage storage)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.timeout,
          receiveTimeout: ApiConfig.timeout,
          contentType: Headers.jsonContentType,
        ))
          ..interceptors.addAll([
            AuthInterceptor(storage),
            if (kDebugMode)
              LogInterceptor(
                requestBody: true,
                responseBody: true,
                logPrint: (o) => debugPrint('$o'),
              ),
          ]);

  final Dio _dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => _dio.post(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put(path, data: data));

  Future<dynamic> patch(String path, {Object? data}) =>
      _send(() => _dio.patch(path, data: data));

  Future<dynamic> delete(String path) => _send(() => _dio.delete(path));

  Future<dynamic> _send(Future<Response> Function() request) async {
    try {
      return (await request()).data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
