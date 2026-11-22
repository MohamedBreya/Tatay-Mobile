import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/booking_enums.dart';

/// Label and colors for each booking status (exhaustive, unknown values included).
({String label, Color fg, Color bg}) bookingStatusStyle(BookingStatus status) => switch (status) {
  BookingStatus.pendingPayment => (
    label: LocaleKeys.bookings_status_pending_payment.tr(),
    fg: AppColors.warning,
    bg: AppColors.warningLight,
  ),
  BookingStatus.pendingReview => (
    label: LocaleKeys.bookings_status_pending_review.tr(),
    fg: AppColors.info,
    bg: AppColors.infoLight,
  ),
  BookingStatus.confirmed => (
    label: LocaleKeys.bookings_status_confirmed.tr(),
    fg: AppColors.success,
    bg: AppColors.successLight,
  ),
  BookingStatus.boarded => (
    label: LocaleKeys.bookings_status_boarded.tr(),
    fg: AppColors.success,
    bg: AppColors.successLight,
  ),
  BookingStatus.refundDue => (
    label: LocaleKeys.bookings_status_refund_due.tr(),
    fg: AppColors.warning,
    bg: AppColors.warningLight,
  ),
  BookingStatus.refunded => (
    label: LocaleKeys.bookings_status_refunded.tr(),
    fg: AppColors.info,
    bg: AppColors.infoLight,
  ),
  BookingStatus.expired => (
    label: LocaleKeys.bookings_status_expired.tr(),
    fg: AppColors.neutral,
    bg: AppColors.neutralLight,
  ),
  BookingStatus.cancelled => (
    label: LocaleKeys.bookings_status_cancelled.tr(),
    fg: AppColors.neutral,
    bg: AppColors.neutralLight,
  ),
  BookingStatus.rejected => (
    label: LocaleKeys.bookings_status_rejected.tr(),
    fg: AppColors.danger,
    bg: AppColors.dangerLight,
  ),
  BookingStatus.noShow => (
    label: LocaleKeys.bookings_status_no_show.tr(),
    fg: AppColors.danger,
    bg: AppColors.dangerLight,
  ),
  BookingStatus.unknown => (
    label: LocaleKeys.bookings_status_unknown.tr(),
    fg: AppColors.neutral,
    bg: AppColors.neutralLight,
  ),
};
