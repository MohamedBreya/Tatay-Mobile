import 'package:json_annotation/json_annotation.dart';

part 'paged_model.g.dart';

/// The contract list shape `{ items, page, per_page, total }`.
@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PagedModel<T> {
  const PagedModel({required this.items, required this.page, required this.perPage, required this.total});

  factory PagedModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagedModelFromJson(json, fromJsonT);

  final List<T> items;
  final int page;
  final int perPage;
  final int total;

  bool get hasMore => page * perPage < total;
}
