import '../../../auth/data/models/user_model.dart';
import '../models/account_requests.dart';

abstract interface class AccountDataSource {
  Future<UserModel> getMe();

  Future<void> changePassword(ChangePasswordRequest body);

  Future<void> registerDevice(RegisterDeviceRequest body);

  Future<void> unregisterDevice(String token);
}
