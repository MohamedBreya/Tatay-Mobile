import 'package:json_annotation/json_annotation.dart';

import 'notification_target_model.dart';

part 'notification_model.g.dart';

@JsonSerializable(createToJson: false)
class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.target,
    required this.sentAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  final String id;

  /// Kept as a string: new types may appear and must not crash the app.
  final String type;
  final String title;
  final String body;
  final NotificationTargetModel target;
  final DateTime sentAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;

  NotificationModel markRead(DateTime at) =>
      NotificationModel(id: id, type: type, title: title, body: body, target: target, sentAt: sentAt, readAt: at);
}
