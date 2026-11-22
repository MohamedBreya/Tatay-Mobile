import 'package:json_annotation/json_annotation.dart';

part 'app_config_model.g.dart';

/// `GET /config`: payment number, support phone, timings and policy texts.
@JsonSerializable(createToJson: false)
class AppConfigModel {
  const AppConfigModel({
    required this.paymentAccountNumber,
    required this.supportPhone,
    required this.paymentHoldMinutes,
    required this.waitlistOfferMinutes,
    required this.bookingCloseMinutes,
    required this.maxSeatsPerBooking,
    required this.boardingWaitMinutes,
    required this.scanWindowMinutes,
    required this.refundHours,
    required this.policies,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => _$AppConfigModelFromJson(json);

  final String paymentAccountNumber;
  final String supportPhone;
  final int paymentHoldMinutes;
  final int waitlistOfferMinutes;
  final int bookingCloseMinutes;
  final int maxSeatsPerBooking;
  final int boardingWaitMinutes;
  final int scanWindowMinutes;
  final int refundHours;
  final PoliciesModel policies;
}

@JsonSerializable(createToJson: false)
class PoliciesModel {
  const PoliciesModel({required this.noCancellation, required this.boardingWait, required this.noShow});

  factory PoliciesModel.fromJson(Map<String, dynamic> json) => _$PoliciesModelFromJson(json);

  final String noCancellation;
  final String boardingWait;
  final String noShow;
}
