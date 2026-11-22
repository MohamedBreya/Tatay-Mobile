import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_enums.dart';
import '../../../data/models/trip_model.dart';

/// The card button, from `availability` and the passenger's own booking/waitlist.
class TripCardAction extends StatelessWidget {
  const TripCardAction({super.key, required this.trip, required this.onOpenTrip});

  final TripModel trip;
  final VoidCallback onOpenTrip;

  @override
  Widget build(BuildContext context) {
    final entryId = trip.myWaitlistEntryId;
    if (trip.hasActiveWaitlist && entryId != null) {
      return trip.myWaitlistStatus == WaitlistStatus.offered
          ? FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
              onPressed: () => context.push(AppRoutes.waitlistOfferFor(entryId)),
              icon: const Icon(Icons.notifications_active_rounded),
              label: Text(LocaleKeys.trips_offer_ready.tr()),
            )
          : OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
              onPressed: onOpenTrip,
              icon: const Icon(Icons.hourglass_top_rounded),
              label: Text(LocaleKeys.trips_in_waitlist.tr()),
            );
    }
    final bookingId = trip.myBookingId;
    if (bookingId != null) {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
        onPressed: () => context.push(AppRoutes.bookingDetailsFor(bookingId)),
        icon: const Icon(Icons.confirmation_number_outlined),
        label: Text(LocaleKeys.trips_view_booking.tr()),
      );
    }
    return switch (trip.availability) {
      Availability.available => FilledButton(
        style: FilledButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
        onPressed: onOpenTrip,
        child: Text(LocaleKeys.trips_book.tr()),
      ),
      Availability.full => OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
        onPressed: onOpenTrip,
        child: Text(LocaleKeys.trips_join_waitlist.tr()),
      ),
      Availability.closed ||
      Availability.unknown => FilledButton(onPressed: null, child: Text(LocaleKeys.trips_closed.tr())),
    };
  }
}
