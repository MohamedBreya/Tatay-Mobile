import 'package:json_annotation/json_annotation.dart';

import 'trip_model.dart';

part 'trip_list_model.g.dart';

/// `TripList` (`{ items }` without paging), used by return suggestions.
@JsonSerializable(createToJson: false)
class TripListModel {
  const TripListModel({required this.items});

  factory TripListModel.fromJson(Map<String, dynamic> json) => _$TripListModelFromJson(json);

  final List<TripModel> items;
}
