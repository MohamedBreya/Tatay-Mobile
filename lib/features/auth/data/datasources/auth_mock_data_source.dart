import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../models/auth_requests.dart';
import '../models/otp_sent_model.dart';
import '../models/token_response_model.dart';
import 'auth_data_source.dart';

class AuthMockDataSource implements AuthDataSource {
  AuthMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<OtpSentModel> register(RegisterRequest body) async {
    await _db.behavior.latency();
    if (_db.users.any((u) => u['phone'] == body.phone)) {
      throw MockApiError.server(409, 'DUPLICATE_PHONE', 'رقم الموبايل ده متسجل قبل كده.');
    }
    if (_db.users.any((u) => u['email'] == body.email.toLowerCase())) {
      throw MockApiError.server(409, 'DUPLICATE_EMAIL', 'الإيميل ده متسجل قبل كده.');
    }
    _db.users.add({
      'id': _db.newId(),
      'role': 'passenger',
      'name': body.name,
      'phone': body.phone,
      'email': body.email.toLowerCase(),
      'email_verified': false,
      'created_at': MockDatabase.iso(_db.now()),
      '_password': body.password,
    });
    return OtpSentModel(resendAvailableInSeconds: 60, email: body.email);
  }

  @override
  Future<TokenResponseModel> verifyEmail(VerifyEmailRequest body) async {
    await _db.behavior.latency();
    if (body.code != MockDatabase.otpCode) {
      throw MockApiError.server(400, 'OTP_INVALID', 'الكود غلط. اتأكد منه وجرب تاني.');
    }
    final user = _findUser(body.email);
    user['email_verified'] = true;
    return _tokensFor(user);
  }

  @override
  Future<OtpSentModel> resendOtp(ResendOtpRequest body) async {
    await _db.behavior.latency();
    return const OtpSentModel(resendAvailableInSeconds: 60);
  }

  @override
  Future<TokenResponseModel> login(LoginRequest body) async {
    await _db.behavior.latency();
    final id = body.identifier.trim().toLowerCase();
    final user = _db.users.where((u) => u['email'] == id || u['phone'] == id).firstOrNull;
    if (user == null || user['_password'] != body.password) {
      throw MockApiError.server(401, 'INVALID_CREDENTIALS', 'الإيميل أو الموبايل أو كلمة السر غلط.');
    }
    return _tokensFor(user);
  }

  @override
  Future<void> logout(LogoutRequest body) async {
    _db.currentUserId = null;
  }

  @override
  Future<OtpSentModel> forgotPassword(EmailRequest body) async {
    await _db.behavior.latency();
    return const OtpSentModel(resendAvailableInSeconds: 60);
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest body) async {
    await _db.behavior.latency();
    if (body.code != MockDatabase.otpCode) {
      throw MockApiError.server(400, 'OTP_INVALID', 'الكود غلط. اتأكد منه وجرب تاني.');
    }
    _db.users.where((u) => u['email'] == body.email.toLowerCase()).firstOrNull?['_password'] = body.newPassword;
  }

  Map<String, dynamic> _findUser(String email) {
    final user = _db.users.where((u) => u['email'] == email.toLowerCase()).firstOrNull;
    if (user == null) {
      throw MockApiError.server(400, 'OTP_INVALID', 'الكود غلط. اتأكد منه وجرب تاني.');
    }
    return user;
  }

  TokenResponseModel _tokensFor(Map<String, dynamic> user) {
    _db.currentUserId = user['id'] as String;
    return TokenResponseModel.fromJson({
      'access_token': 'mock-access-${user['id']}',
      'refresh_token': 'mock-refresh-${user['id']}',
      'token_type': 'Bearer',
      'expires_in': 900,
      'user': _db.publicUser(user),
    });
  }
}
