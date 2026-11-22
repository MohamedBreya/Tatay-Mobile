import 'package:json_annotation/json_annotation.dart';

/// Unknown values from a newer backend map to `unknown` instead of crashing.
enum Direction {
  outbound,
  @JsonValue('return')
  returnTrip,
  unknown,
}

enum Availability { available, full, closed, unknown }

enum TripStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  @JsonValue('not_operated')
  notOperated,
  unknown,
}

enum WaitlistStatus { waiting, offered, accepted, declined, expired, left, closed, unknown }
