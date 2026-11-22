import 'package:json_annotation/json_annotation.dart';

part 'create_booking_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateBookingRequest {
  const CreateBookingRequest({required this.tripId, required this.stopId, required this.seats});

  final String tripId;
  final String stopId;
  final int seats;

  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}
