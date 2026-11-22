import '../models/scan_request.dart';
import '../models/scan_result_model.dart';

abstract interface class BoardingDataSource {
  Future<ScanResultModel> scan(String idempotencyKey, ScanRequest body);
}
