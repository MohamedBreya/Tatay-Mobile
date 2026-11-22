import 'dart:convert';

import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/data/models/user_model.dart';
import '../datasources/account_data_source.dart';
import '../models/account_requests.dart';

class AccountRepository {
  AccountRepository(this._source, this._storage);

  final AccountDataSource _source;
  final TokenStorage _storage;

  Future<Result<UserModel>> getMe() => safeCall(() async {
    final user = await _source.getMe();
    await _storage.saveUserJson(jsonEncode(user.toJson()));
    return user;
  });

  Future<Result<void>> changePassword({required String currentPassword, required String newPassword}) => safeCall(
    () => _source.changePassword(ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword)),
  );

  Future<Result<void>> registerDevice(String token) =>
      safeCall(() => _source.registerDevice(RegisterDeviceRequest(token: token)));

  Future<Result<void>> unregisterDevice(String token) => safeCall(() => _source.unregisterDevice(token));
}
