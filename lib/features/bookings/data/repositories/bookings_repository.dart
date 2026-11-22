import '../../../../core/network/idempotent_call.dart';
import '../../../../core/network/paged_model.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/safe_call.dart';
import '../datasources/bookings_data_source.dart';
import '../models/booking_enums.dart';
import '../models/booking_model.dart';
import '../models/create_booking_request.dart';

class BookingsRepository {
  BookingsRepository(this._source);

  final BookingsDataSource _source;

  /// One call per button press. Retries reuse the same Idempotency-Key.
  Future<Result<BookingModel>> createBooking({required String tripId, required String stopId, required int seats}) =>
      idempotentCall(
        (key) => _source.createBooking(key, CreateBookingRequest(tripId: tripId, stopId: stopId, seats: seats)),
      );

  Future<Result<PagedModel<BookingModel>>> listMyBookings(BookingScope scope, {int page = 1}) =>
      safeCall(() => _source.listMyBookings(scope: scope.name, page: page, perPage: 20));

  Future<Result<BookingModel>> getBooking(String bookingId) => safeCall(() => _source.getBooking(bookingId));
}
