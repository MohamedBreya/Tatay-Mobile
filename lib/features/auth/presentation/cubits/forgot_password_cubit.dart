import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._auth) : super(const ForgotPasswordIdle());

  final AuthRepository _auth;

  Future<void> submit(String email) async {
    if (state is ForgotPasswordSubmitting) return;
    emit(const ForgotPasswordSubmitting());
    final result = await _auth.forgotPassword(email);
    emit(switch (result) {
      Success(:final data) => ForgotPasswordSent(email: email.trim(), resendInSeconds: data.resendAvailableInSeconds),
      Failure(:final failure) => ForgotPasswordFailed(failure),
    });
  }
}
