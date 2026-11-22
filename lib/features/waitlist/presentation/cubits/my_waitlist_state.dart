import '../../../../core/network/api_failure.dart';
import '../../data/models/waitlist_entry_model.dart';

sealed class MyWaitlistState {
  const MyWaitlistState();
}

final class MyWaitlistLoading extends MyWaitlistState {
  const MyWaitlistLoading();
}

final class MyWaitlistLoaded extends MyWaitlistState {
  const MyWaitlistLoaded(this.entries, {this.leavingId, this.leaveFailure});

  final List<WaitlistEntryModel> entries;

  /// The entry being removed right now (its button shows a spinner).
  final String? leavingId;
  final ApiFailure? leaveFailure;
}

final class MyWaitlistError extends MyWaitlistState {
  const MyWaitlistError(this.failure);

  final ApiFailure failure;
}
