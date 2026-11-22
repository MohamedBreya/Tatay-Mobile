import 'dart:io';

import '../../../../core/network/paged_model.dart';
import '../models/booking_model.dart';
import '../models/create_booking_request.dart';

abstract interface class BookingsDataSource {
  Future<BookingModel> createBooking(String idempotencyKey, CreateBookingRequest body);

  /// [scope] is `active` or `past`.
  Future<PagedModel<BookingModel>> listMyBookings({String? scope, int? page, int? perPage});

  Future<BookingModel> getBooking(String bookingId);

  /// JPG or PNG under 5 MB, sent as the `image` multipart field.
  Future<BookingModel> uploadPaymentProof(String bookingId, String idempotencyKey, File image);
}
