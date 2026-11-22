import 'package:json_annotation/json_annotation.dart';

part 'auth_requests.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequest {
  const RegisterRequest({required this.name, required this.phone, required this.email, required this.password});

  final String name;
  final String phone;
  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class LoginRequest {
  const LoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class VerifyEmailRequest {
  const VerifyEmailRequest({required this.email, required this.code});

  final String email;
  final String code;

  Map<String, dynamic> toJson() => _$VerifyEmailRequestToJson(this);
}

enum OtpPurpose {
  @JsonValue('verify_email')
  verifyEmail,
  @JsonValue('reset_password')
  resetPassword,
}

@JsonSerializable(createFactory: false)
class ResendOtpRequest {
  const ResendOtpRequest({required this.email, required this.purpose});

  final String email;
  final OtpPurpose purpose;

  Map<String, dynamic> toJson() => _$ResendOtpRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class EmailRequest {
  const EmailRequest({required this.email});

  final String email;

  Map<String, dynamic> toJson() => _$EmailRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class ResetPasswordRequest {
  const ResetPasswordRequest({required this.email, required this.code, required this.newPassword});

  final String email;
  final String code;
  final String newPassword;

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class LogoutRequest {
  const LogoutRequest({required this.refreshToken, this.deviceToken});

  final String refreshToken;
  final String? deviceToken;

  Map<String, dynamic> toJson() => _$LogoutRequestToJson(this);
}
