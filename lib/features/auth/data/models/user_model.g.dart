// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  role: json['role'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  emailVerified: json['email_verified'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'email_verified': instance.emailVerified,
  'created_at': instance.createdAt.toIso8601String(),
};
