import '../../../../core/network/api_failure.dart';
import '../../data/models/booking_model.dart';

sealed class MyBookingsState {
  const MyBookingsState();
}

final class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

final class MyBookingsLoaded extends MyBookingsState {
  const MyBookingsLoaded({required this.items, required this.page, required this.hasMore, this.loadingMore = false});

  final List<BookingModel> items;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  MyBookingsLoaded copyWith({List<BookingModel>? items, int? page, bool? hasMore, bool? loadingMore}) =>
      MyBookingsLoaded(
        items: items ?? this.items,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final class MyBookingsError extends MyBookingsState {
  const MyBookingsError(this.failure);

  final ApiFailure failure;
}
