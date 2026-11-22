import '../../../../core/network/paged_model.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../models/join_waitlist_request.dart';
import '../models/waitlist_entry_model.dart';

abstract interface class WaitlistDataSource {
  Future<WaitlistEntryModel> joinWaitlist(String tripId, String idempotencyKey, JoinWaitlistRequest body);

  Future<PagedModel<WaitlistEntryModel>> listMyWaitlist({int? page, int? perPage});

  Future<WaitlistEntryModel> getEntry(String entryId);

  Future<void> leave(String entryId);

  /// Creates a `pending_payment` booking with the normal payment hold.
  Future<BookingModel> accept(String entryId, String idempotencyKey);

  Future<WaitlistEntryModel> decline(String entryId);
}
