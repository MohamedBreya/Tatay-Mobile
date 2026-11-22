// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponseModel _$TokenResponseModelFromJson(Map<String, dynamic> json) => TokenResponseModel(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
);
