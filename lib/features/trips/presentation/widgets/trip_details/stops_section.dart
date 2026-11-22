import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_model.dart';
import 'stop_tile.dart';

/// Stops in order with their times. When [onSelect] is set, the passenger picks one.
class StopsSection extends StatelessWidget {
  const StopsSection({super.key, required this.trip, this.selectedStopId, this.onSelect});

  final TripModel trip;
  final String? selectedStopId;
  final ValueChanged<String>? onSelect;

  @override
  Widget build(BuildContext context) {
    final stops = [...trip.stops]..sort((a, b) => a.sequence.compareTo(b.sequence));
    return SectionCard(
      title: onSelect == null ? LocaleKeys.trip_details_stops.tr() : LocaleKeys.trip_details_pick_stop.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final stop in stops)
            StopTile(
              stop: stop,
              selected: stop.id == selectedStopId,
              onTap: onSelect == null ? null : () => onSelect!(stop.id),
            ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.danger, size: 20),
              const SizedBox(width: 8),
              Text(LocaleKeys.trip_details_arrival.tr(args: [trip.arrivalPoint]), style: AppStyles.bodySecondary),
            ],
          ),
        ],
      ),
    );
  }
}
