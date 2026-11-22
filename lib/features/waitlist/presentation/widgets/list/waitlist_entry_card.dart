import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/confirm_dialog.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../trips/data/models/trip_enums.dart';
import '../../../data/models/waitlist_entry_model.dart';
import '../shared/waitlist_trip_summary.dart';

class WaitlistEntryCard extends StatelessWidget {
  const WaitlistEntryCard({super.key, required this.entry, required this.leaving, required this.onLeave});

  final WaitlistEntryModel entry;
  final bool leaving;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final position = entry.position;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WaitlistTripSummary(entry: entry),
            const SizedBox(height: 8),
            Text(
              [
                LocaleKeys.common_seats.plural(entry.seats),
                if (position != null) LocaleKeys.waitlist_position.tr(args: ['$position']),
              ].join(' · '),
              style: AppStyles.label,
            ),
            if (entry.status == WaitlistStatus.offered) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push(AppRoutes.waitlistOfferFor(entry.id)),
                child: Text(LocaleKeys.waitlist_view_offer.tr()),
              ),
            ],
            if (entry.isActive)
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: leaving
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : TextButton(
                        onPressed: () async {
                          final ok = await ConfirmDialog.show(
                            context,
                            message: LocaleKeys.waitlist_leave_confirm.tr(),
                            confirmLabel: LocaleKeys.waitlist_leave.tr(),
                          );
                          if (ok) onLeave();
                        },
                        child: Text(LocaleKeys.waitlist_leave.tr()),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
