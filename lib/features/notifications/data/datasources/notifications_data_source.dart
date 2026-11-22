import '../models/notifications_page_model.dart';

abstract interface class NotificationsDataSource {
  Future<NotificationsPageModel> list({bool? unreadOnly, int? page, int? perPage});

  Future<void> markRead(String notificationId);
}
