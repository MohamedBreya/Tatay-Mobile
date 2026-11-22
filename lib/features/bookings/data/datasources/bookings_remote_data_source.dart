import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/paged_model.dart';
import '../models/booking_model.dart';
import '../models/create_booking_request.dart';
import 'bookings_data_source.dart';

part 'bookings_remote_data_source.g.dart';

@RestApi()
abstract class BookingsRemoteDataSource implements BookingsDataSource {
  factory BookingsRemoteDataSource(Dio dio, {String? baseUrl}) = _BookingsRemoteDataSource;

  @override
  @POST('/bookings')
  Future<BookingModel> createBooking(
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() CreateBookingRequest body,
  );

  @override
  @GET('/bookings')
  Future<PagedModel<BookingModel>> listMyBookings({
    @Query('scope') String? scope,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @override
  @GET('/bookings/{id}')
  Future<BookingModel> getBooking(@Path('id') String bookingId);

  @override
  @POST('/bookings/{id}/payment-proof')
  @MultiPart()
  Future<BookingModel> uploadPaymentProof(
    @Path('id') String bookingId,
    @Header('Idempotency-Key') String idempotencyKey,
    @Part(name: 'image', contentType: 'image/jpeg') File image,
  );
}
