import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../../trips/data/models/trip_enums.dart';
import '../../../data/models/booking_enums.dart';
import '../../../data/models/booking_model.dart';
import 'booking_note.dart';

/// refund_due: amount and the latest date it arrives. refunded: amount, date, reference.
class BookingRefundNote extends StatelessWidget {
  const BookingRefundNote({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final amount = AppFormat.money(booking.refundAmount ?? booking.amount);
    final reason = switch (booking.trip.status) {
      TripStatus.cancelled => LocaleKeys.bookings_trip_cancelled.tr(),
      TripStatus.notOperated => LocaleKeys.bookings_trip_not_operated.tr(),
      _ => null,
    };
    if (booking.status == BookingStatus.refunded) {
      final at = booking.refundedAt;
      final reference = booking.refundReference;
      return BookingNote(
        icon: Icons.task_alt_rounded,
        color: AppColors.info,
        background: AppColors.infoLight,
        lines: [
          LocaleKeys.bookings_refunded_on.tr(args: [amount, at == null ? '' : AppFormat.dayAndTime(at)]),
          if (reference != null) LocaleKeys.bookings_refund_reference.tr(args: [reference]),
        ],
      );
    }
    final dueAt = booking.refundDueAt;
    return BookingNote(
      icon: Icons.currency_exchange_rounded,
      color: AppColors.warning,
      background: AppColors.warningLight,
      lines: [
        ?reason,
        LocaleKeys.bookings_refund_amount.tr(args: [amount]),
        if (dueAt != null) LocaleKeys.bookings_refund_by.tr(args: [AppFormat.dayAndTime(dueAt)]),
      ],
    );
  }
}
