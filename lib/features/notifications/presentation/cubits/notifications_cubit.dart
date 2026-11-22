import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/notifications_repository.dart';
import '../../data/repositories/push_repository.dart';
import 'notifications_state.dart';

/// The notifications list and the unread badge. Every notification is stored on the
/// server, so this list is complete even when a push never arrived.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository, PushRepository push) : super(const NotificationsLoading()) {
    _pushSub = push.onForegroundMessage.listen((_) => refresh());
  }

  final NotificationsRepository _repository;
  late final StreamSubscription<void> _pushSub;

  Future<void> load() async {
    emit(const NotificationsLoading());
    await refresh();
  }

  Future<void> refresh() async {
    final result = await _repository.list();
    switch (result) {
      case Success(:final data):
        emit(NotificationsLoaded(items: data.items, unread: data.unreadCount, page: 1, hasMore: data.hasMore));
      case Failure(:final failure):
        if (state is! NotificationsLoaded) emit(NotificationsError(failure));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsLoaded || !current.hasMore || current.loadingMore) {
      return;
    }
    emit(current.copyWith(loadingMore: true));
    final result = await _repository.list(page: current.page + 1);
    switch (result) {
      case Success(:final data):
        emit(
          current.copyWith(
            items: [...current.items, ...data.items],
            unread: data.unreadCount,
            page: current.page + 1,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case Failure():
        emit(current.copyWith(loadingMore: false));
    }
  }

  /// Optimistic: the badge drops at once, the server call happens in the background.
  Future<void> markRead(String notificationId) async {
    final current = state;
    if (current is NotificationsLoaded) {
      final target = current.items.where((n) => n.id == notificationId).firstOrNull;
      if (target != null && !target.isRead) {
        emit(
          current.copyWith(
            items: [for (final n in current.items) n.id == notificationId ? n.markRead(DateTime.now().toUtc()) : n],
            unread: current.unread > 0 ? current.unread - 1 : 0,
          ),
        );
      }
    }
    await _repository.markRead(notificationId);
  }

  void reset() => emit(const NotificationsLoading());

  @override
  Future<void> close() async {
    await _pushSub.cancel();
    return super.close();
  }
}
