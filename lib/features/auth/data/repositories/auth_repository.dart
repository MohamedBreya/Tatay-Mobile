import 'dart:convert';

import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../core/storage/token_storage.dart';
import '../datasources/auth_data_source.dart';
import '../models/auth_requests.dart';
import '../models/otp_sent_model.dart';
import '../models/token_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository(this._source, this._storage);

  final AuthDataSource _source;
  final TokenStorage _storage;

  bool get hasSession => _storage.hasSession;

  Future<Result<OtpSentModel>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) => safeCall(
    () => _source.register(
      RegisterRequest(name: name.trim(), phone: phone.trim(), email: email.trim(), password: password),
    ),
  );

  Future<Result<UserModel>> verifyEmail({required String email, required String code}) =>
      safeCall(() async => _persist(await _source.verifyEmail(VerifyEmailRequest(email: email, code: code))));

  Future<Result<OtpSentModel>> resendOtp({required String email, required OtpPurpose purpose}) =>
      safeCall(() => _source.resendOtp(ResendOtpRequest(email: email, purpose: purpose)));

  Future<Result<UserModel>> login({required String identifier, required String password}) => safeCall(
    () async => _persist(await _source.login(LoginRequest(identifier: identifier.trim(), password: password))),
  );

  Future<Result<OtpSentModel>> forgotPassword(String email) =>
      safeCall(() => _source.forgotPassword(EmailRequest(email: email.trim())));

  Future<Result<void>> resetPassword({required String email, required String code, required String newPassword}) =>
      safeCall(() => _source.resetPassword(ResetPasswordRequest(email: email, code: code, newPassword: newPassword)));

  /// Always clears local state, even when the server call fails (offline logout).
  Future<void> logout({String? deviceToken}) async {
    final refresh = _storage.refreshToken;
    if (refresh != null) {
      await safeCall(() => _source.logout(LogoutRequest(refreshToken: refresh, deviceToken: deviceToken)));
    }
    await _storage.clear();
  }

  Future<UserModel?> cachedUser() async {
    await _storage.load();
    final json = await _storage.readUserJson();
    if (json == null || !_storage.hasSession) return null;
    try {
      return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> _persist(TokenResponseModel tokens) async {
    await _storage.saveTokens(access: tokens.accessToken, refresh: tokens.refreshToken);
    await _storage.saveUserJson(jsonEncode(tokens.user.toJson()));
    return tokens.user;
  }
}
