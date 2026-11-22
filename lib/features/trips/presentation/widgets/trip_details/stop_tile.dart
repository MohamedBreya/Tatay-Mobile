import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/stop_model.dart';

/// One stop with its time. Selectable as the pick-up point when [onTap] is set.
class StopTile extends StatelessWidget {
  const StopTile({super.key, required this.stop, required this.selected, this.onTap});

  final StopModel stop;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = stop.notOperated;
    return Material(
      color: selected ? AppColors.primaryLight : AppColors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                color: disabled ? AppColors.textMuted : AppColors.primary,
                size: onTap == null ? 0 : 22,
              ),
              if (onTap != null) const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.name,
                      style: disabled
                          ? AppStyles.body.copyWith(color: AppColors.textMuted, decoration: TextDecoration.lineThrough)
                          : AppStyles.subtitle,
                    ),
                    if (disabled) Text(LocaleKeys.trip_details_stop_cancelled.tr(), style: AppStyles.error),
                  ],
                ),
              ),
              Text(AppFormat.time(stop.scheduledAt), style: AppStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}
