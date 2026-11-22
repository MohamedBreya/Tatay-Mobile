import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/state/action_status.dart';
import '../../data/repositories/auth_repository.dart';

/// State is a plain [ActionStatus]: success carries no data, the user logs in again.
class ResetPasswordCubit extends Cubit<ActionStatus> {
  ResetPasswordCubit(this._auth, {required this.email}) : super(const ActionIdle());

  final AuthRepository _auth;
  final String email;

  Future<void> submit({required String code, required String newPassword}) async {
    if (state is ActionInProgress) return;
    emit(const ActionInProgress());
    final result = await _auth.resetPassword(email: email, code: code.trim(), newPassword: newPassword);
    emit(switch (result) {
      Success() => const ActionSucceeded(),
      Failure(:final failure) => ActionFailed(failure),
    });
  }
}
