import 'package:dio/dio.dart';

/// Seule erreur remontée par la couche réseau : les écrans affichent
/// directement [message], sans connaître Dio.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const ApiException('Délai dépassé. Réessayez.'),
        DioExceptionType.connectionError =>
          const ApiException('Impossible de se connecter. Vérifiez votre connexion.'),
        _ => ApiException(
            _serverMessage(e.response?.data) ?? 'Une erreur est survenue. Réessayez.',
            statusCode: e.response?.statusCode,
          ),
      };

  static String? _serverMessage(Object? data) =>
      data is Map ? data['message'] as String? : null;

  @override
  String toString() => message;
}
