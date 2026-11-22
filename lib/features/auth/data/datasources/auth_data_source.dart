import '../models/auth_requests.dart';
import '../models/otp_sent_model.dart';
import '../models/token_response_model.dart';

abstract interface class AuthDataSource {
  Future<OtpSentModel> register(RegisterRequest body);

  Future<TokenResponseModel> verifyEmail(VerifyEmailRequest body);

  Future<OtpSentModel> resendOtp(ResendOtpRequest body);

  Future<TokenResponseModel> login(LoginRequest body);

  Future<void> logout(LogoutRequest body);

  Future<OtpSentModel> forgotPassword(EmailRequest body);

  Future<void> resetPassword(ResetPasswordRequest body);
}
