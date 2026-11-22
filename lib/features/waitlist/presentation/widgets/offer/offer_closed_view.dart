import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/result_message.dart';
import '../../../../../generated/locale_keys.g.dart';

/// "The offer expired" or "OK, the seat goes to the next person".
class OfferClosedView extends StatelessWidget {
  const OfferClosedView({super.key, required this.declined, this.bookingId});

  final bool declined;
  final String? bookingId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ResultMessage(
          icon: declined ? Icons.check_circle_outline_rounded : Icons.timer_off_rounded,
          color: declined ? AppColors.info : AppColors.danger,
          background: declined ? AppColors.infoLight : AppColors.dangerLight,
          title: declined ? LocaleKeys.waitlist_declined_done.tr() : LocaleKeys.waitlist_offer_expired_title.tr(),
          body: declined ? '' : LocaleKeys.waitlist_offer_expired_body.tr(),
        ),
        if (bookingId != null)
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
