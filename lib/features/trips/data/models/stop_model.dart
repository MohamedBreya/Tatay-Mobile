import 'package:json_annotation/json_annotation.dart';

part 'stop_model.g.dart';

@JsonSerializable(createToJson: false)
class StopModel {
  const StopModel({
    required this.id,
    required this.sequence,
    required this.name,
    required this.scheduledAt,
    required this.notOperated,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) => _$StopModelFromJson(json);

  final String id;
  final int sequence;
  final String name;
  final DateTime scheduledAt;
  final bool notOperated;
}
