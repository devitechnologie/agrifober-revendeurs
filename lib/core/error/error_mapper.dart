import 'package:dio/dio.dart';
// local imports
import 'failure.dart';

const _noConnectionMessage = 'Pas de connexion internet.';
const _timeoutMessage = 'Le serveur met trop de temps à répondre. Réessayez.';
const _genericMessage = 'Une erreur est survenue. Veuillez réessayer.';

Failure handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(_timeoutMessage);
    case DioExceptionType.connectionError:
      return const NetworkFailure(_noConnectionMessage);
    case DioExceptionType.badResponse:
      return _handleBadResponse(e);
    default:
      return const NetworkFailure(_genericMessage);
  }
}

/// The reseller API answers every error with `{ message, errors? }`, the
/// message already in French — surface it as is.
Failure _handleBadResponse(DioException e) {
  final response = e.response;
  final statusCode = response?.statusCode;
  final message = _apiMessage(response) ?? _genericMessage;

  if (statusCode == 422 ||
      statusCode == 409 ||
      statusCode == 429 ||
      statusCode == 403) {
    return ValidationFailure(
      _validationMessage(response) ?? message,
      code: statusCode,
    );
  }

  return ServerFailure(message, code: statusCode);
}

String? _apiMessage(Response? response) {
  final data = response?.data;
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return null;
}

/// For a 422, the first field error is more useful than the generic
/// "Données invalides." headline.
String? _validationMessage(Response? response) {
  final data = response?.data;
  if (data is! Map) return null;
  final errors = data['errors'];
  if (errors is Map) {
    for (final fieldErrors in errors.values) {
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      }
    }
  }
  return null;
}
