import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_requests.dart';
import '../models/otp_sent_model.dart';
import '../models/token_response_model.dart';
import 'auth_data_source.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource implements AuthDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) = _AuthRemoteDataSource;

  @override
  @POST('/auth/register')
  Future<OtpSentModel> register(@Body() RegisterRequest body);

  @override
  @POST('/auth/verify-email')
  Future<TokenResponseModel> verifyEmail(@Body() VerifyEmailRequest body);

  @override
  @POST('/auth/resend-otp')
  Future<OtpSentModel> resendOtp(@Body() ResendOtpRequest body);

  @override
  @POST('/auth/login')
  Future<TokenResponseModel> login(@Body() LoginRequest body);

  @override
  @POST('/auth/logout')
  Future<void> logout(@Body() LogoutRequest body);

  @override
  @POST('/auth/forgot-password')
  Future<OtpSentModel> forgotPassword(@Body() EmailRequest body);

  @override
  @POST('/auth/reset-password')
  Future<void> resetPassword(@Body() ResetPasswordRequest body);
}
