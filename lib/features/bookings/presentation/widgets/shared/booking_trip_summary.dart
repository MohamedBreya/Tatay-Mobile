import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../trips/data/models/trip_enums.dart';
import '../../../data/models/booking_model.dart';
import 'booking_status_chip.dart';

/// Day, pick-up time and stop, direction, and the status chip.
class BookingTripSummary extends StatelessWidget {
  const BookingTripSummary({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final outbound = booking.trip.direction != Direction.returnTrip;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
          child: Icon(outbound ? Icons.location_city_rounded : Icons.home_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppFormat.dayAndTime(booking.stop.scheduledAt), style: AppStyles.subtitle),
              Text(booking.stop.name, style: AppStyles.bodySecondary),
              Text(LocaleKeys.trips_to.tr(args: [booking.trip.arrivalPoint]), style: AppStyles.caption),
            ],
          ),
        ),
        BookingStatusChip(status: booking.status),
      ],
    );
  }
}
