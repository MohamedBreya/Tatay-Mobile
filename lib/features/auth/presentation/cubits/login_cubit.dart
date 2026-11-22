import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._auth) : super(const LoginIdle());

  final AuthRepository _auth;

  Future<void> submit({required String identifier, required String password}) async {
    if (state is LoginSubmitting) return;
    emit(const LoginSubmitting());
    final result = await _auth.login(identifier: identifier, password: password);
    emit(switch (result) {
      Success(:final data) => LoginSucceeded(data),
      Failure(:final failure) => LoginFailed(failure),
    });
  }
}
