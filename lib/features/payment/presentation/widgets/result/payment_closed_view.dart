import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/result_message.dart';
import '../../../../../generated/locale_keys.g.dart';

/// Expired hold, or a booking that is not waiting for payment any more.
class PaymentClosedView extends StatelessWidget {
  const PaymentClosedView({super.key, required this.expired, this.bookingId});

  final bool expired;
  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ResultMessage(
          icon: expired ? Icons.timer_off_rounded : Icons.info_outline_rounded,
          color: expired ? AppColors.danger : AppColors.info,
          background: expired ? AppColors.dangerLight : AppColors.infoLight,
          title: expired ? LocaleKeys.payment_expired_title.tr() : LocaleKeys.payment_not_payable.tr(),
          body: expired ? LocaleKeys.payment_expired_body.tr() : '',
        ),
        if (!expired && bookingId != null)
          FilledButton(
            onPressed: () => context.pushReplacement(AppRoutes.bookingDetailsFor(bookingId!)),
            child: Text(LocaleKeys.trips_view_booking.tr()),
          )
        else
          FilledButton(onPressed: () => context.go(AppRoutes.trips), child: Text(LocaleKeys.common_back_to_trips.tr())),
      ],
    );
  }
}
