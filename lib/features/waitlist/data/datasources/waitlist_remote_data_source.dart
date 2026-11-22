import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/paged_model.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../models/join_waitlist_request.dart';
import '../models/waitlist_entry_model.dart';
import 'waitlist_data_source.dart';

part 'waitlist_remote_data_source.g.dart';

@RestApi()
abstract class WaitlistRemoteDataSource implements WaitlistDataSource {
  factory WaitlistRemoteDataSource(Dio dio, {String? baseUrl}) = _WaitlistRemoteDataSource;

  @override
  @POST('/trips/{tripId}/waitlist')
  Future<WaitlistEntryModel> joinWaitlist(
    @Path('tripId') String tripId,
    @Header('Idempotency-Key') String idempotencyKey,
    @Body() JoinWaitlistRequest body,
  );

  @override
  @GET('/waitlist')
  Future<PagedModel<WaitlistEntryModel>> listMyWaitlist({@Query('page') int? page, @Query('per_page') int? perPage});

  @override
  @GET('/waitlist/{id}')
  Future<WaitlistEntryModel> getEntry(@Path('id') String entryId);

  @override
  @DELETE('/waitlist/{id}')
  Future<void> leave(@Path('id') String entryId);

  @override
  @POST('/waitlist/{id}/accept')
  Future<BookingModel> accept(@Path('id') String entryId, @Header('Idempotency-Key') String idempotencyKey);

  @override
  @POST('/waitlist/{id}/decline')
  Future<WaitlistEntryModel> decline(@Path('id') String entryId);
}
