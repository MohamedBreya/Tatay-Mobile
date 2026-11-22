import '../../../../core/network/idempotent_call.dart';
import '../../../../core/network/result.dart';
import '../datasources/boarding_data_source.dart';
import '../models/scan_request.dart';
import '../models/scan_result_model.dart';

class BoardingRepository {
  BoardingRepository(this._source);

  final BoardingDataSource _source;

  Future<Result<ScanResultModel>> scan(String qrToken) =>
      idempotentCall((key) => _source.scan(key, ScanRequest(qrToken: qrToken)));
}
