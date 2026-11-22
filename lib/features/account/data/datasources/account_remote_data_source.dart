import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../auth/data/models/user_model.dart';
import '../models/account_requests.dart';
import 'account_data_source.dart';

part 'account_remote_data_source.g.dart';

@RestApi()
abstract class AccountRemoteDataSource implements AccountDataSource {
  factory AccountRemoteDataSource(Dio dio, {String? baseUrl}) = _AccountRemoteDataSource;

  @override
  @GET('/me')
  Future<UserModel> getMe();

  @override
  @POST('/me/password')
  Future<void> changePassword(@Body() ChangePasswordRequest body);

  @override
  @POST('/me/devices')
  Future<void> registerDevice(@Body() RegisterDeviceRequest body);

  @override
  @DELETE('/me/devices/{token}')
  Future<void> unregisterDevice(@Path('token') String token);
}
