import 'package:json_annotation/json_annotation.dart';

part 'account_requests.g.dart';

@JsonSerializable(createFactory: false)
class ChangePasswordRequest {
  const ChangePasswordRequest({required this.currentPassword, required this.newPassword});

  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class RegisterDeviceRequest {
  const RegisterDeviceRequest({required this.token, this.platform = 'android'});

  final String token;
  final String platform;

  Map<String, dynamic> toJson() => _$RegisterDeviceRequestToJson(this);
}
