import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/network/api_client.dart';
import '../services/storage/token_storage.dart';

final tokenStorageProvider = Provider((_) => const TokenStorage());

final apiClientProvider =
    Provider((ref) => ApiClient(ref.watch(tokenStorageProvider)));
