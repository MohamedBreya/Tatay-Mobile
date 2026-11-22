import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/app_snack.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../config/presentation/cubits/config_cubit.dart';
import '../cubits/trip_details_cubit.dart';
import '../cubits/trip_details_state.dart';
import '../widgets/trip_details/trip_details_body.dart';
import '../widgets/trip_details/trip_details_bottom_bar.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context) {
    final config = context.read<ConfigCubit>().config;
    return BlocProvider(
      create: (_) =>
          TripDetailsCubit(sl(), sl(), sl(), tripId: tripId, maxSeats: config?.maxSeatsPerBooking ?? 2)..load(),
      child: BlocConsumer<TripDetailsCubit, TripDetailsState>(
        listener: (context, state) {
          if (state is! TripDetailsLoaded) return;
          if (state.booking case final booking?) {
            context.pushReplacement(AppRoutes.paymentFor(booking.id));
          } else if (state.waitlistEntry case final entry?) {
            AppSnack.show(context, LocaleKeys.trip_details_waitlist_joined.tr(args: ['${entry.position ?? '-'}']));
            context.pop();
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.trip_details_title.tr())),
          body: switch (state) {
            TripDetailsLoading() => const LoadingView(),
            TripDetailsError(:final failure) => ErrorView(
              failure: failure,
              onRetry: context.read<TripDetailsCubit>().load,
            ),
            TripDetailsLoaded() => TripDetailsBody(state: state, config: config),
          },
          bottomNavigationBar: switch (state) {
            TripDetailsLoaded(:final trip) when trip.myBookingId == null && !trip.hasActiveWaitlist =>
              TripDetailsBottomBar(state: state, offerMinutes: config?.waitlistOfferMinutes ?? 5),
            _ => null,
          },
        ),
      ),
    );
  }
}
