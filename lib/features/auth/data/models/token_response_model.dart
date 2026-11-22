import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'token_response_model.g.dart';

@JsonSerializable(createToJson: false)
class TokenResponseModel {
  const TokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) => _$TokenResponseModelFromJson(json);

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;
}
