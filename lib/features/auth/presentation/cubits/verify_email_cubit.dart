import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/auth_repository.dart';
import 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit(this._auth, {required this.email}) : super(const VerifyEmailIdle());

  final AuthRepository _auth;
  final String email;

  Future<void> submit(String code) async {
    if (state is VerifyEmailSubmitting) return;
    emit(const VerifyEmailSubmitting());
    final result = await _auth.verifyEmail(email: email, code: code.trim());
    emit(switch (result) {
      Success(:final data) => VerifyEmailSucceeded(data),
      Failure(:final failure) => VerifyEmailFailed(failure),
    });
  }
}
