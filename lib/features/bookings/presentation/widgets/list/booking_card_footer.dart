import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/booking_enums.dart';
import '../../../data/models/booking_model.dart';

/// Seats and amount, plus the one action that matters for the current status.
class BookingCardFooter extends StatelessWidget {
  const BookingCardFooter({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final action = switch (booking.status) {
      BookingStatus.pendingPayment => FilledButton(
        style: FilledButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
        onPressed: () => context.push(AppRoutes.paymentFor(booking.id)),
        child: Text(LocaleKeys.bookings_pay_now.tr()),
      ),
      BookingStatus.confirmed when booking.canScanAt(DateTime.now().toUtc()) => FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
        onPressed: () => context.push(AppRoutes.scan),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: Text(LocaleKeys.bookings_scan.tr()),
      ),
      _ => null,
    };
    final refund = booking.refundAmount;
    return Row(
      children: [
        Expanded(
          child: Text(
            booking.status == BookingStatus.refundDue && refund != null
                ? LocaleKeys.bookings_refund_amount.tr(args: [AppFormat.money(refund)])
                : '${LocaleKeys.common_seats.plural(booking.seats)} · ${AppFormat.money(booking.amount)}',
            style: AppStyles.label,
          ),
        ),
        ?action,
      ],
    );
  }
}
