import '../../../../core/mock/mock_api_error.dart';
import '../../../../core/mock/mock_database.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/account_requests.dart';
import 'account_data_source.dart';

class AccountMockDataSource implements AccountDataSource {
  AccountMockDataSource(this._db);

  final MockDatabase _db;

  @override
  Future<UserModel> getMe() async {
    await _db.behavior.latency();
    final user = _db.userById(_db.currentUserId) ?? _db.users.first;
    _db.currentUserId = user['id'] as String;
    return UserModel.fromJson(_db.publicUser(user));
  }

  @override
  Future<void> changePassword(ChangePasswordRequest body) async {
    await _db.behavior.latency();
    final user = _db.userById(_db.currentUserId)!;
    if (user['_password'] != body.currentPassword) {
      throw MockApiError.server(401, 'INVALID_CREDENTIALS', 'كلمة السر الحالية غلط.');
    }
    user['_password'] = body.newPassword;
  }

  @override
  Future<void> registerDevice(RegisterDeviceRequest body) async {}

  @override
  Future<void> unregisterDevice(String token) async {}
}
