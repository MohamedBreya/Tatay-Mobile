import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// The `Me` schema.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
    required this.email,
    required this.emailVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  final String id;
  final String role;
  final String name;
  final String phone;
  final String email;
  final bool emailVerified;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({bool? emailVerified}) => UserModel(
    id: id,
    role: role,
    name: name,
    phone: phone,
    email: email,
    emailVerified: emailVerified ?? this.emailVerified,
    createdAt: createdAt,
  );
}
