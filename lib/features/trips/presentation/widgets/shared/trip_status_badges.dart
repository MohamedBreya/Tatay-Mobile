import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/status_chip.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_enums.dart';
import '../../../data/models/trip_model.dart';

/// Seats left / full / closed, and confirmed or "runs if N people book".
class TripStatusBadges extends StatelessWidget {
  const TripStatusBadges({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        switch (trip.availability) {
          Availability.available => StatusChip(
            label: LocaleKeys.trips_seats_left.plural(trip.availableSeats),
            foreground: AppColors.success,
            background: AppColors.successLight,
            icon: Icons.event_seat_rounded,
          ),
          Availability.full => StatusChip(
            label: LocaleKeys.trips_full.tr(),
            foreground: AppColors.danger,
            background: AppColors.dangerLight,
          ),
          Availability.closed || Availability.unknown => StatusChip(
            label: LocaleKeys.trips_closed.tr(),
            foreground: AppColors.neutral,
            background: AppColors.neutralLight,
          ),
        },
        trip.isConfirmed
            ? StatusChip(
                label: LocaleKeys.trips_confirmed.tr(),
                foreground: AppColors.info,
                background: AppColors.infoLight,
                icon: Icons.verified_rounded,
              )
            : StatusChip(
                label: LocaleKeys.trips_confirm_threshold.tr(args: ['${trip.minPassengers}']),
                foreground: AppColors.warning,
                background: AppColors.warningLight,
              ),
      ],
    );
  }
}
