import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/result_message.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../bookings/data/models/booking_model.dart';
import '../../../../trips/data/models/trip_enums.dart';
import '../../../../trips/presentation/widgets/return_suggestions/return_suggestions_section.dart';

/// "We got the screenshot", plus same-day return trips after an outbound booking.
class PaymentSubmittedView extends StatelessWidget {
  const PaymentSubmittedView({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ResultMessage(
          icon: Icons.mark_email_read_rounded,
          color: AppColors.success,
          background: AppColors.successLight,
          title: LocaleKeys.payment_uploaded_title.tr(),
          body: LocaleKeys.payment_uploaded_body.tr(),
        ),
        FilledButton(
          onPressed: () => context.go(AppRoutes.bookings),
          child: Text(LocaleKeys.payment_go_to_bookings.tr()),
        ),
        const SizedBox(height: 20),
        if (booking.trip.direction == Direction.outbound) ReturnSuggestionsSection(outboundTripId: booking.trip.id),
      ],
    );
  }
}
