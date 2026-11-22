import '../../../../core/network/idempotent_call.dart';
import '../../../../core/network/paged_model.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../datasources/waitlist_data_source.dart';
import '../models/join_waitlist_request.dart';
import '../models/waitlist_entry_model.dart';

class WaitlistRepository {
  WaitlistRepository(this._source);

  final WaitlistDataSource _source;

  Future<Result<WaitlistEntryModel>> join({required String tripId, required String stopId, required int seats}) =>
      idempotentCall((key) => _source.joinWaitlist(tripId, key, JoinWaitlistRequest(stopId: stopId, seats: seats)));

  Future<Result<PagedModel<WaitlistEntryModel>>> listMine({int page = 1}) =>
      safeCall(() => _source.listMyWaitlist(page: page, perPage: 50));

  Future<Result<WaitlistEntryModel>> getEntry(String entryId) => safeCall(() => _source.getEntry(entryId));

  Future<Result<void>> leave(String entryId) => safeCall(() => _source.leave(entryId));

  Future<Result<BookingModel>> accept(String entryId) => idempotentCall((key) => _source.accept(entryId, key));

  Future<Result<WaitlistEntryModel>> decline(String entryId) => safeCall(() => _source.decline(entryId));
}
