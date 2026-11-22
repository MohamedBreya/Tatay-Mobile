import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../models/notifications_page_model.dart';
import 'notifications_data_source.dart';

class NotificationsMockDataSource implements NotificationsDataSource {
  NotificationsMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<NotificationsPageModel> list({bool? unreadOnly, int? page, int? perPage}) async {
    await _db.behavior.latency();
    _db.tick();
    final p = page ?? 1;
    final size = perPage ?? 20;
    final all = _db.notifications.where((n) => unreadOnly != true || n['read_at'] == null).toList();
    return NotificationsPageModel.fromJson({
      'items': all.skip((p - 1) * size).take(size).toList(),
      'page': p,
      'per_page': size,
      'total': all.length,
      'unread_count': _db.notifications.where((n) => n['read_at'] == null).length,
    });
  }

  @override
  Future<void> markRead(String notificationId) async {
    final n = _db.notifications.where((n) => n['id'] == notificationId).firstOrNull;
    if (n == null) {
      throw MockApiError.server(404, 'NOT_FOUND', 'الإشعار ده مش موجود.');
    }
    n['read_at'] ??= MockDatabase.iso(_db.now());
  }
}
