import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/empty_view.dart';
import '../../../../../core/widgets/error_view.dart';
import '../../../../../core/widgets/loading_view.dart';
import '../../cubits/my_bookings_cubit.dart';
import '../../cubits/my_bookings_state.dart';
import 'booking_card.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key, required this.emptyMessage});

  final String emptyMessage;

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cubit = context.read<MyBookingsCubit>();
    return BlocBuilder<MyBookingsCubit, MyBookingsState>(
      builder: (context, state) => switch (state) {
        MyBookingsLoading() => const LoadingView(),
        MyBookingsError(:final failure) => ErrorView(failure: failure, onRetry: cubit.load),
        MyBookingsLoaded(:final items) when items.isEmpty => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: EmptyView(message: widget.emptyMessage, icon: Icons.confirmation_number_outlined),
        ),
        MyBookingsLoaded(:final items, :final loadingMore) => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 200) cubit.loadMore();
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: items.length + (loadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  i == items.length ? const LoadingView() : BookingCard(booking: items[i], onReturn: cubit.refresh),
            ),
          ),
        ),
      },
    );
  }
}
