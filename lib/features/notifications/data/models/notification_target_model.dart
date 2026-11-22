import 'package:json_annotation/json_annotation.dart';

part 'notification_target_model.g.dart';

enum TargetScreen {
  booking,
  trip,
  @JsonValue('waitlist_offer')
  waitlistOffer,
  unknown,
}

/// Which screen a notification opens (deep link). Also built from FCM `data`.
@JsonSerializable(createToJson: false)
class NotificationTargetModel {
  const NotificationTargetModel({required this.screen, this.bookingId, this.tripId, this.waitlistEntryId});

  factory NotificationTargetModel.fromJson(Map<String, dynamic> json) => _$NotificationTargetModelFromJson(json);

  /// FCM sends every value as a string, with `""` for empty ids.
  factory NotificationTargetModel.fromPushData(Map<String, dynamic> data) {
    String? id(String key) {
      final value = data[key];
      return value is String && value.isNotEmpty ? value : null;
    }

    return NotificationTargetModel.fromJson({
      'screen': data['screen'],
      'booking_id': id('booking_id'),
      'trip_id': id('trip_id'),
      'waitlist_entry_id': id('waitlist_entry_id'),
    });
  }

  @JsonKey(unknownEnumValue: TargetScreen.unknown)
  final TargetScreen screen;
  final String? bookingId;
  final String? tripId;
  final String? waitlistEntryId;
}
