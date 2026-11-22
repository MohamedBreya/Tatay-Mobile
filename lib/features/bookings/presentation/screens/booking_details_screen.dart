import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../config/presentation/cubits/config_cubit.dart';
import '../cubits/booking_details_cubit.dart';
import '../cubits/booking_details_state.dart';
import '../widgets/details/booking_info_card.dart';
import '../widgets/details/booking_status_section.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final config = context.read<ConfigCubit>().config;
    return BlocProvider(
      create: (_) => BookingDetailsCubit(sl(), bookingId: bookingId)..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.bookings_details_title.tr())),
        body: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
          builder: (context, state) {
            final cubit = context.read<BookingDetailsCubit>();
            return switch (state) {
              BookingDetailsLoading() => const LoadingView(),
              BookingDetailsError(:final failure) => ErrorView(failure: failure, onRetry: cubit.load),
              BookingDetailsLoaded(:final booking) => RefreshIndicator(
                onRefresh: cubit.load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    BookingInfoCard(booking: booking),
                    const SizedBox(height: 12),
                    BookingStatusSection(
                      state: state,
                      supportPhone: config?.supportPhone,
                      scanWindowMinutes: config?.scanWindowMinutes ?? 15,
                    ),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
