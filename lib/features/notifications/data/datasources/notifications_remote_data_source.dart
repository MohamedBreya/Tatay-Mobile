import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/notifications_page_model.dart';
import 'notifications_data_source.dart';

part 'notifications_remote_data_source.g.dart';

@RestApi()
abstract class NotificationsRemoteDataSource implements NotificationsDataSource {
  factory NotificationsRemoteDataSource(Dio dio, {String? baseUrl}) = _NotificationsRemoteDataSource;

  @override
  @GET('/notifications')
  Future<NotificationsPageModel> list({
    @Query('unread_only') bool? unreadOnly,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @override
  @POST('/notifications/{id}/read')
  Future<void> markRead(@Path('id') String notificationId);
}
