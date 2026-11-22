import 'package:json_annotation/json_annotation.dart';

part 'otp_sent_model.g.dart';

/// `OtpSentResponse` and `RegisterResponse` both carry the resend cooldown.
@JsonSerializable(createToJson: false)
class OtpSentModel {
  const OtpSentModel({required this.resendAvailableInSeconds, this.email});

  factory OtpSentModel.fromJson(Map<String, dynamic> json) => _$OtpSentModelFromJson(json);

  final int resendAvailableInSeconds;
  final String? email;
}
