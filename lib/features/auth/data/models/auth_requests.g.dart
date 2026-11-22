// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'password': instance.password,
};

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) => <String, dynamic>{
  'identifier': instance.identifier,
  'password': instance.password,
};

Map<String, dynamic> _$VerifyEmailRequestToJson(VerifyEmailRequest instance) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
};

Map<String, dynamic> _$ResendOtpRequestToJson(ResendOtpRequest instance) => <String, dynamic>{
  'email': instance.email,
  'purpose': _$OtpPurposeEnumMap[instance.purpose]!,
};

const _$OtpPurposeEnumMap = {OtpPurpose.verifyEmail: 'verify_email', OtpPurpose.resetPassword: 'reset_password'};

Map<String, dynamic> _$EmailRequestToJson(EmailRequest instance) => <String, dynamic>{'email': instance.email};

Map<String, dynamic> _$ResetPasswordRequestToJson(ResetPasswordRequest instance) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'new_password': instance.newPassword,
};

Map<String, dynamic> _$LogoutRequestToJson(LogoutRequest instance) => <String, dynamic>{
  'refresh_token': instance.refreshToken,
  'device_token': ?instance.deviceToken,
};
