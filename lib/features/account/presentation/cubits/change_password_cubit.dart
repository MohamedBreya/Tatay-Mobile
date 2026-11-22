import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../../../core/state/action_status.dart';
import '../../data/repositories/account_repository.dart';

class ChangePasswordCubit extends Cubit<ActionStatus> {
  ChangePasswordCubit(this._repository) : super(const ActionIdle());

  final AccountRepository _repository;

  Future<void> submit({required String currentPassword, required String newPassword}) async {
    if (state is ActionInProgress) return;
    emit(const ActionInProgress());
    final result = await _repository.changePassword(currentPassword: currentPassword, newPassword: newPassword);
    emit(switch (result) {
      Success() => const ActionSucceeded(),
      Failure(:final failure) => ActionFailed(failure),
    });
  }
}
