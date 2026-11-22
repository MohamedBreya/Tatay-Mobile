import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';
import '../network/api_error_code.dart';
import '../network/api_failure.dart';

/// The text to show for a failure. Server messages are Arabic and safe to show as is;
/// a few codes get a client wording from the API guide.
String failureMessage(ApiFailure failure) => switch (failure) {
  NetworkFailure() => LocaleKeys.errors_network.tr(),
  SessionExpiredFailure() => LocaleKeys.errors_session_expired.tr(),
  UnexpectedFailure() => LocaleKeys.errors_generic.tr(),
  ServerFailure(code: ApiErrorCode.invalidCredentials) => LocaleKeys.errors_invalid_credentials.tr(),
  ServerFailure(code: ApiErrorCode.payloadTooLarge) => LocaleKeys.errors_payload_too_large.tr(),
  ServerFailure(:final message) when message.isNotEmpty => message,
  ServerFailure() => LocaleKeys.errors_generic.tr(),
};

/// `request_id` to show under generic errors, so a bug can be found in the logs.
String? failureRequestId(ApiFailure failure) => switch (failure) {
  ServerFailure(:final requestId, :final code)
      when code == ApiErrorCode.internalError || code == ApiErrorCode.unknown =>
    requestId,
  UnexpectedFailure(:final requestId) => requestId,
  _ => null,
};
