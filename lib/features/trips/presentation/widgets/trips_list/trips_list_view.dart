import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../data/models/trip_model.dart';
import 'day_header.dart';
import 'trip_card.dart';

/// Trips grouped by day, with pull to refresh.
class TripsListView extends StatelessWidget {
  const TripsListView({super.key, required this.byDay, required this.onRefresh});

  final Map<DateTime, List<TripModel>> byDay;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (final MapEntry(value: trips) in byDay.entries) {
      rows.add(DayHeader(label: AppFormat.day(trips.first.departureAt)));
      for (final trip in trips) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TripCard(
              trip: trip,
              onOpenTrip: () async {
                await context.push(AppRoutes.tripDetailsFor(trip.id));
                await onRefresh();
              },
            ),
          ),
        );
      }
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: rows,
      ),
    );
  }
}
