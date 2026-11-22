import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/app_config_model.dart';
import 'config_data_source.dart';

part 'config_remote_data_source.g.dart';

@RestApi()
abstract class ConfigRemoteDataSource implements ConfigDataSource {
  factory ConfigRemoteDataSource(Dio dio, {String? baseUrl}) = _ConfigRemoteDataSource;

  @override
  @GET('/config')
  Future<AppConfigModel> getConfig();
}
