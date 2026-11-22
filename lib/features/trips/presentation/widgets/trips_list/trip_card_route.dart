import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_model.dart';

/// Departure time, first stop and arrival point.
class TripCardRoute extends StatelessWidget {
  const TripCardRoute({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final firstStop = trip.stops.isEmpty ? '' : trip.stops.first.name;
    return Row(
      children: [
        Text(AppFormat.time(trip.departureAt), style: AppStyles.headline),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.trip_origin_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(firstStop, style: AppStyles.body, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 14, color: AppColors.danger),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      LocaleKeys.trips_to.tr(args: [trip.arrivalPoint]),
                      style: AppStyles.bodySecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
