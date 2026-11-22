import 'notification_target_model.dart';

/// A push the passenger tapped: where to go, and which stored notification to mark read.
class OpenedPushModel {
  const OpenedPushModel({required this.target, this.notificationId});

  factory OpenedPushModel.fromData(Map<String, dynamic> data) {
    final id = data['notification_id'];
    return OpenedPushModel(
      target: NotificationTargetModel.fromPushData(data),
      notificationId: id is String && id.isNotEmpty ? id : null,
    );
  }

  final NotificationTargetModel target;
  final String? notificationId;
}
