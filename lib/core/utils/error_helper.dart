import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/core/error/index.dart';

class ErrorHelper {
  static String getErrorFromState(AsyncValue state) {
    if (!state.hasError) return '';

    final error = state.error;
    if (error is Failure) {
      return error.message;
    }

    return error?.toString() ?? 'Une erreur inattendue s\'est produite';
  }

  static bool hasError(AsyncValue state) {
    return state.hasError;
  }

  static String getErrorMessage(Object error) {
    if (error is Failure) {
      return error.message;
    }
    return error.toString();
  }
}
