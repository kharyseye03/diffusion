import 'package:dio/dio.dart';
import '../../services/storage/token_storage.dart';

/// Ajoute le Bearer token à chaque requête.
///
/// Le renouvellement sur 401 sera ajouté ici quand l'endpoint de
/// refresh sera connu.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final TokenStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}
