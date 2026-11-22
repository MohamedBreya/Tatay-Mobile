import 'package:json_annotation/json_annotation.dart';

part 'scan_request.g.dart';

@JsonSerializable(createFactory: false)
class ScanRequest {
  const ScanRequest({required this.qrToken});

  /// The raw text read from the vehicle sticker, sent as is.
  final String qrToken;

  Map<String, dynamic> toJson() => _$ScanRequestToJson(this);
}
