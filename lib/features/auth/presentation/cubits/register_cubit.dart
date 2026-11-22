import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._auth) : super(const RegisterIdle());

  final AuthRepository _auth;

  Future<void> submit({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    if (state is RegisterSubmitting) return;
    emit(const RegisterSubmitting());
    final result = await _auth.register(name: name, phone: phone, email: email, password: password);
    emit(switch (result) {
      Success(:final data) => RegisterSucceeded(
        email: data.email ?? email.trim(),
        resendInSeconds: data.resendAvailableInSeconds,
      ),
      Failure(:final failure) => RegisterFailed(failure),
    });
  }
}
