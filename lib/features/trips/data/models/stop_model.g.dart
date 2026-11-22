// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopModel _$StopModelFromJson(Map<String, dynamic> json) => StopModel(
  id: json['id'] as String,
  sequence: (json['sequence'] as num).toInt(),
  name: json['name'] as String,
  scheduledAt: DateTime.parse(json['scheduled_at'] as String),
  notOperated: json['not_operated'] as bool,
);
