import '../config/api/api_config.dart';
import '../core/network/api_client.dart';

class AuthService {
  const AuthService(this._client);

  final ApiClient _client;

  /// Rôle attribué à tout compte créé depuis l'app.
  static const _role = 'GROSSISTE';

  Future<void> register(String phoneNumber) => _client.post(
        ApiConfig.register,
        data: {'phoneNumber': phoneNumber, 'role': _role},
      );

  Future<void> verifyOtp(String phoneNumber, String code) => _client.post(
        ApiConfig.verifyOtp,
        data: {'phoneNumber': phoneNumber, 'code': code},
      );

  Future<void> resendOtp(String phoneNumber) => _client.post(
        ApiConfig.resendOtp,
        data: {'phoneNumber': phoneNumber},
      );

  Future<void> createPin(String phoneNumber, String pin) => _client.post(
        ApiConfig.createPin,
        data: {'phoneNumber': phoneNumber, 'pin': pin},
      );
}
