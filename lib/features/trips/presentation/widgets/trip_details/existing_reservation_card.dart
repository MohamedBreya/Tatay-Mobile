import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_enums.dart';
import '../../../data/models/trip_model.dart';

/// Replaces the booking form when the passenger already booked or is on the waitlist.
class ExistingReservationCard extends StatelessWidget {
  const ExistingReservationCard({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final bookingId = trip.myBookingId;
    final entryId = trip.myWaitlistEntryId;
    final offered = trip.myWaitlistStatus == WaitlistStatus.offered;
    final (label, action) = bookingId != null
        ? (LocaleKeys.trips_view_booking.tr(), () => context.push(AppRoutes.bookingDetailsFor(bookingId)))
        : offered && entryId != null
        ? (LocaleKeys.trips_offer_ready.tr(), () => context.push(AppRoutes.waitlistOfferFor(entryId)))
        : (LocaleKeys.trips_in_waitlist.tr(), null);
    return Card(
      color: AppColors.primaryLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              bookingId != null ? Icons.confirmation_number_rounded : Icons.hourglass_top_rounded,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppStyles.subtitle)),
            if (action != null)
              IconButton(onPressed: action, icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18)),
          ],
        ),
      ),
    );
  }
}
