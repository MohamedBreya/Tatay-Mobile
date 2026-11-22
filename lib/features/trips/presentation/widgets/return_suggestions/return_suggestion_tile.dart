import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../data/models/trip_model.dart';
import '../shared/trip_status_badges.dart';

class ReturnSuggestionTile extends StatelessWidget {
  const ReturnSuggestionTile({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.tripDetailsFor(trip.id)),
      title: Text(AppFormat.time(trip.departureAt), style: AppStyles.title),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: TripStatusBadges(trip: trip),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
