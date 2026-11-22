import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/status_chip.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../trips/data/models/trip_enums.dart';

class WaitlistStatusChip extends StatelessWidget {
  const WaitlistStatusChip({super.key, required this.status});

  final WaitlistStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg) = switch (status) {
      WaitlistStatus.waiting => (LocaleKeys.waitlist_status_waiting.tr(), AppColors.info, AppColors.infoLight),
      WaitlistStatus.offered => (LocaleKeys.waitlist_status_offered.tr(), AppColors.success, AppColors.successLight),
      WaitlistStatus.accepted => (LocaleKeys.waitlist_status_accepted.tr(), AppColors.success, AppColors.successLight),
      WaitlistStatus.declined => (LocaleKeys.waitlist_status_declined.tr(), AppColors.neutral, AppColors.neutralLight),
      WaitlistStatus.expired => (LocaleKeys.waitlist_status_expired.tr(), AppColors.neutral, AppColors.neutralLight),
      WaitlistStatus.left => (LocaleKeys.waitlist_status_left.tr(), AppColors.neutral, AppColors.neutralLight),
      WaitlistStatus.closed => (LocaleKeys.waitlist_status_closed.tr(), AppColors.neutral, AppColors.neutralLight),
      WaitlistStatus.unknown => (LocaleKeys.waitlist_status_unknown.tr(), AppColors.neutral, AppColors.neutralLight),
    };
    return StatusChip(label: label, foreground: fg, background: bg);
  }
}
