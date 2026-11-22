import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';

/// 1 or 2 seats (up to `max_seats_per_booking`), no seat choice, plus the total.
class SeatsSelector extends StatelessWidget {
  const SeatsSelector({
    super.key,
    required this.seats,
    required this.maxSeats,
    required this.total,
    required this.onChanged,
  });

  final int seats;
  final int maxSeats;
  final int total;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: LocaleKeys.trip_details_seats.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              for (var n = 1; n <= maxSeats; n++)
                ButtonSegment(value: n, label: Text(LocaleKeys.common_seats.plural(n))),
            ],
            selected: {seats},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(LocaleKeys.trip_details_total.tr(), style: AppStyles.subtitle),
              const Spacer(),
              Text(AppFormat.money(total), style: AppStyles.price),
            ],
          ),
        ],
      ),
    );
  }
}
