import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_model.dart';
import '../shared/trip_status_badges.dart';
import 'trip_card_action.dart';
import 'trip_card_route.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onOpenTrip});

  final TripModel trip;
  final VoidCallback onOpenTrip;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenTrip,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TripCardRoute(trip: trip),
              const SizedBox(height: 12),
              TripStatusBadges(trip: trip),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: AppFormat.money(trip.seatPrice), style: AppStyles.price),
                          TextSpan(text: ' ${LocaleKeys.trips_per_seat.tr()}', style: AppStyles.caption),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(child: TripCardAction(trip: trip, onOpenTrip: onOpenTrip)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
