import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/paged_model.dart';
import '../models/trip_list_model.dart';
import '../models/trip_model.dart';
import 'trips_data_source.dart';

part 'trips_remote_data_source.g.dart';

@RestApi()
abstract class TripsRemoteDataSource implements TripsDataSource {
  factory TripsRemoteDataSource(Dio dio, {String? baseUrl}) = _TripsRemoteDataSource;

  @override
  @GET('/trips')
  Future<PagedModel<TripModel>> listTrips({
    @Query('direction') String? direction,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  });

  @override
  @GET('/trips/{id}')
  Future<TripModel> getTrip(@Path('id') String tripId);

  @override
  @GET('/trips/{id}/return-suggestions')
  Future<TripListModel> getReturnSuggestions(@Path('id') String tripId);
}
