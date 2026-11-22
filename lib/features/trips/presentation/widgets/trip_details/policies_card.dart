import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../config/data/models/app_config_model.dart';

/// No cancellation, the 5-minute wait, and no refund for no-shows, shown before
/// confirming (US-3.1, US-4.3). The passenger must tick the box to continue.
class PoliciesCard extends StatelessWidget {
  const PoliciesCard({super.key, required this.policies, required this.agreed, required this.onChanged});

  final PoliciesModel? policies;
  final bool agreed;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final texts = [policies?.noCancellation, policies?.boardingWait, policies?.noShow].whereType<String>();
    return Card(
      color: AppColors.warningLight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(LocaleKeys.trip_details_policies_title.tr(), style: AppStyles.subtitle),
            const SizedBox(height: 8),
            for (final text in texts)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(child: Text(text, style: AppStyles.body)),
                  ],
                ),
              ),
            CheckboxListTile(
              value: agreed,
              onChanged: (v) => onChanged(v ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(LocaleKeys.trip_details_agree.tr(), style: AppStyles.subtitle),
            ),
          ],
        ),
      ),
    );
  }
}
