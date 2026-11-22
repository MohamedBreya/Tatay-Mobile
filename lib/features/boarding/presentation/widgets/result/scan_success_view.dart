import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/scan_result_model.dart';
import 'scan_success_row.dart';

/// Full-screen green confirmation, big enough for the driver to read at a glance.
class ScanSuccessView extends StatelessWidget {
  const ScanSuccessView({super.key, required this.result});

  final ScanResultModel result;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.successBright,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.check_circle_rounded, size: 120, color: AppColors.textOnDark),
              const SizedBox(height: 16),
              Text(
                result.alreadyBoarded
                    ? LocaleKeys.boarding_already_boarded.tr()
                    : LocaleKeys.boarding_success_title.tr(),
                style: AppStyles.successHeadline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ScanSuccessRow(label: LocaleKeys.boarding_passenger.tr(), value: result.passengerName),
              ScanSuccessRow(
                label: LocaleKeys.bookings_seats.tr(),
                value: LocaleKeys.common_seats.plural(result.seats),
              ),
              ScanSuccessRow(label: LocaleKeys.boarding_stop.tr(), value: result.stopName),
              ScanSuccessRow(label: LocaleKeys.boarding_vehicle.tr(), value: result.vehiclePlateNumber),
              const Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textOnDark,
                  side: const BorderSide(color: AppColors.textOnDark),
                ),
                onPressed: () => context.pop(),
                child: Text(LocaleKeys.boarding_done.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
