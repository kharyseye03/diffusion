import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'api_exception.dart';

/// Gère pour tous les écrans l'état de chargement et l'affichage des
/// erreurs d'un appel API.
mixin ApiCallMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  /// Renvoie `true` si l'appel a réussi. En cas d'échec, le message de
  /// l'[ApiException] est affiché dans une SnackBar.
  Future<bool> callApi(Future<void> Function() call) async {
    if (isLoading) return false;
    setState(() => isLoading = true);
    try {
      await call();
      return true;
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
      return false;
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
