import '../../../../core/network/api_failure.dart';
import '../../data/models/notification_model.dart';

sealed class NotificationsState {
  const NotificationsState();

  int get unreadCount => 0;
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.items,
    required this.unread,
    required this.page,
    required this.hasMore,
    this.loadingMore = false,
  });

  final List<NotificationModel> items;
  final int unread;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  @override
  int get unreadCount => unread;

  NotificationsLoaded copyWith({
    List<NotificationModel>? items,
    int? unread,
    int? page,
    bool? hasMore,
    bool? loadingMore,
  }) => NotificationsLoaded(
    items: items ?? this.items,
    unread: unread ?? this.unread,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

final class NotificationsError extends NotificationsState {
  const NotificationsError(this.failure);

  final ApiFailure failure;
}
