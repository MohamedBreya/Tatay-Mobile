import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/waitlist_repository.dart';
import 'my_waitlist_state.dart';

class MyWaitlistCubit extends Cubit<MyWaitlistState> {
  MyWaitlistCubit(this._repository) : super(const MyWaitlistLoading());

  final WaitlistRepository _repository;

  Future<void> load() async {
    emit(const MyWaitlistLoading());
    await refresh();
  }

  Future<void> refresh() async {
    final result = await _repository.listMine();
    switch (result) {
      case Success(:final data):
        emit(MyWaitlistLoaded(data.items));
      case Failure(:final failure):
        if (state is! MyWaitlistLoaded) emit(MyWaitlistError(failure));
    }
  }

  /// Returns true when the passenger left the queue.
  Future<bool> leave(String entryId) async {
    final current = state;
    if (current is! MyWaitlistLoaded || current.leavingId != null) return false;
    emit(MyWaitlistLoaded(current.entries, leavingId: entryId));
    final result = await _repository.leave(entryId);
    switch (result) {
      case Success():
        await refresh();
        return true;
      case Failure(:final failure):
        emit(MyWaitlistLoaded(current.entries, leaveFailure: failure));
        await refresh();
        return false;
    }
  }
}
