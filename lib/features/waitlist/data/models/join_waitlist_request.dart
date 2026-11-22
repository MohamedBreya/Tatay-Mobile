import 'package:json_annotation/json_annotation.dart';

part 'join_waitlist_request.g.dart';

@JsonSerializable(createFactory: false)
class JoinWaitlistRequest {
  const JoinWaitlistRequest({required this.stopId, required this.seats});

  final String stopId;
  final int seats;

  Map<String, dynamic> toJson() => _$JoinWaitlistRequestToJson(this);
}
