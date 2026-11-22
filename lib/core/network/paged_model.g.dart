// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedModel<T> _$PagedModelFromJson<T>(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => PagedModel<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  page: (json['page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);
