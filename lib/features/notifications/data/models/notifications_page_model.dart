import 'package:json_annotation/json_annotation.dart';

import 'notification_model.dart';

part 'notifications_page_model.g.dart';

/// `NotificationPage`: a page plus `unread_count` for the badge.
@JsonSerializable(createToJson: false)
class NotificationsPageModel {
  const NotificationsPageModel({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.unreadCount,
  });

  factory NotificationsPageModel.fromJson(Map<String, dynamic> json) => _$NotificationsPageModelFromJson(json);

  final List<NotificationModel> items;
  final int page;
  final int perPage;
  final int total;
  final int unreadCount;

  bool get hasMore => page * perPage < total;
}
