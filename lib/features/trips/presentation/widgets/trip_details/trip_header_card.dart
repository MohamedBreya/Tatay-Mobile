import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_enums.dart';
import '../../../data/models/trip_model.dart';
import '../shared/trip_status_badges.dart';

class TripHeaderCard extends StatelessWidget {
  const TripHeaderCard({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final closesAt = trip.bookingClosesAt;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  trip.direction == Direction.returnTrip ? Icons.home_rounded : Icons.location_city_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(AppFormat.dayAndTime(trip.departureAt), style: AppStyles.title)),
                Text(AppFormat.money(trip.seatPrice), style: AppStyles.price),
              ],
            ),
            const SizedBox(height: 12),
            TripStatusBadges(trip: trip),
            if (trip.vehicleType != null && trip.vehiclePlateNumber != null) ...[
              const SizedBox(height: 12),
              Text(
                LocaleKeys.trip_details_vehicle.tr(args: [trip.vehicleType!, trip.vehiclePlateNumber!]),
                style: AppStyles.bodySecondary,
              ),
            ],
            if (closesAt != null && trip.availability != Availability.closed)
              Text(
                LocaleKeys.trip_details_booking_closes.tr(args: [AppFormat.dayAndTime(closesAt)]),
                style: AppStyles.caption,
              ),
          ],
        ),
      ),
    );
  }
}
