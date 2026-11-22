// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsPageModel _$NotificationsPageModelFromJson(Map<String, dynamic> json) => NotificationsPageModel(
  items: (json['items'] as List<dynamic>).map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList(),
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  unreadCount: (json['unread_count'] as num).toInt(),
);
