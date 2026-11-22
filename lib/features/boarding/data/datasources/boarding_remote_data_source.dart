import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/scan_request.dart';
import '../models/scan_result_model.dart';
import 'boarding_data_source.dart';

part 'boarding_remote_data_source.g.dart';

@RestApi()
abstract class BoardingRemoteDataSource implements BoardingDataSource {
  factory BoardingRemoteDataSource(Dio dio, {String? baseUrl}) = _BoardingRemoteDataSource;

  @override
  @POST('/boarding/scan')
  Future<ScanResultModel> scan(@Header('Idempotency-Key') String idempotencyKey, @Body() ScanRequest body);
}
