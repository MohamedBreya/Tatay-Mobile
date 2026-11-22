import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../datasources/notifications_data_source.dart';
import '../models/notifications_page_model.dart';

class NotificationsRepository {
  NotificationsRepository(this._source);

  final NotificationsDataSource _source;

  Future<Result<NotificationsPageModel>> list({int page = 1}) => safeCall(() => _source.list(page: page, perPage: 20));

  Future<Result<void>> markRead(String notificationId) => safeCall(() => _source.markRead(notificationId));
}
