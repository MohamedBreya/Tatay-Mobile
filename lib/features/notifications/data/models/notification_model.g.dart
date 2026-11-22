// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) => NotificationModel(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  target: NotificationTargetModel.fromJson(json['target'] as Map<String, dynamic>),
  sentAt: DateTime.parse(json['sent_at'] as String),
  readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at'] as String),
);
