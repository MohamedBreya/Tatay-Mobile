import 'package:json_annotation/json_annotation.dart';

part 'scan_result_model.g.dart';

@JsonSerializable(createToJson: false)
class ScanResultModel {
  const ScanResultModel({
    required this.bookingId,
    required this.seats,
    required this.passengerName,
    required this.stopName,
    required this.vehiclePlateNumber,
    required this.alreadyBoarded,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) => _$ScanResultModelFromJson(json);

  final String bookingId;
  final int seats;
  final String passengerName;
  final String stopName;
  final String vehiclePlateNumber;
  final bool alreadyBoarded;
}
