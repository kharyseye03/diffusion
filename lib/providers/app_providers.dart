import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../services/storage/token_storage.dart';

final tokenStorageProvider = Provider((_) => const TokenStorage());

final apiClientProvider =
    Provider((ref) => ApiClient(ref.watch(tokenStorageProvider)));

final authServiceProvider =
    Provider((ref) => AuthService(
          ref.watch(apiClientProvider),
          ref.watch(tokenStorageProvider),
        ));

final biometricServiceProvider =
    Provider((ref) => BiometricService(ref.watch(tokenStorageProvider)));
