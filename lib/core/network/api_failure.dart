import 'api_error_code.dart';

/// A field-level validation message from `VALIDATION_ERROR`.
class FieldError {
  const FieldError(this.field, this.message);

  final String field;
  final String message;
}

/// Every way an API call can fail, as seen by repositories and cubits.
sealed class ApiFailure {
  const ApiFailure();
}

/// No response at all: offline, timeout, DNS, connection reset.
final class NetworkFailure extends ApiFailure {
  const NetworkFailure();
}

/// The server answered with the contract error body `{ code, message, fields?, details?, request_id }`.
final class ServerFailure extends ApiFailure {
  const ServerFailure({
    required this.code,
    required this.message,
    this.statusCode,
    this.fields = const [],
    this.details = const {},
    this.requestId,
  });

  final ApiErrorCode code;

  /// Arabic, safe to show as is.
  final String message;
  final int? statusCode;
  final List<FieldError> fields;
  final Map<String, dynamic> details;
  final String? requestId;

  String? fieldError(String field) {
    for (final f in fields) {
      if (f.field == field) return f.message;
    }
    return null;
  }

  int? detailInt(String key) {
    final value = details[key];
    return value is int ? value : int.tryParse('$value');
  }

  bool detailBool(String key) => details[key] == true;
}

/// The session ended (refresh failed). The app goes back to login.
final class SessionExpiredFailure extends ApiFailure {
  const SessionExpiredFailure();
}

/// Anything else: unexpected status without a contract body, parsing errors, bugs.
final class UnexpectedFailure extends ApiFailure {
  const UnexpectedFailure([this.requestId]);

  final String? requestId;
}
