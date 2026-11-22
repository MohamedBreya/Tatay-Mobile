import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/support_caller.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/booking_enums.dart';
import '../../cubits/booking_details_cubit.dart';
import '../../cubits/booking_details_state.dart';
import 'booking_note.dart';
import 'booking_refund_note.dart';

/// What the passenger can do or needs to know for the current status.
class BookingStatusSection extends StatelessWidget {
  const BookingStatusSection({super.key, required this.state, this.supportPhone, this.scanWindowMinutes = 15});

  final BookingDetailsLoaded state;
  final String? supportPhone;
  final int scanWindowMinutes;

  @override
  Widget build(BuildContext context) {
    final booking = state.booking;
    final callAdmin = supportPhone == null
        ? null
        : OutlinedButton.icon(
            onPressed: () => SupportCaller.call(supportPhone!),
            icon: const Icon(Icons.call_outlined),
            label: Text(LocaleKeys.common_call_admin.tr()),
          );
    return switch (booking.status) {
      BookingStatus.pendingPayment => BookingNote(
        icon: Icons.timer_outlined,
        color: AppColors.warning,
        background: AppColors.warningLight,
        lines: [
          LocaleKeys.bookings_time_left.tr(args: [AppFormat.countdown(state.secondsLeft ?? 0)]),
        ],
        action: FilledButton(
          onPressed: () async {
            await context.push(AppRoutes.paymentFor(booking.id));
            if (context.mounted) {
              await context.read<BookingDetailsCubit>().load();
            }
          },
          child: Text(LocaleKeys.bookings_pay_now.tr()),
        ),
      ),
      BookingStatus.pendingReview => BookingNote(
        icon: Icons.hourglass_top_rounded,
        color: AppColors.info,
        background: AppColors.infoLight,
        lines: [LocaleKeys.bookings_in_review.tr()],
      ),
      BookingStatus.confirmed => BookingNote(
        icon: Icons.qr_code_2_rounded,
        color: AppColors.success,
        background: AppColors.successLight,
        lines: [
          LocaleKeys.bookings_scan_hint.tr(args: ['$scanWindowMinutes', '$scanWindowMinutes']),
        ],
        action: state.canScan
            ? FilledButton.icon(
                onPressed: () async {
                  await context.push(AppRoutes.scan);
                  if (context.mounted) {
                    await context.read<BookingDetailsCubit>().load();
                  }
                },
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: Text(LocaleKeys.bookings_scan.tr()),
              )
            : null,
      ),
      BookingStatus.boarded => BookingNote(
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
        background: AppColors.successLight,
        lines: [
          LocaleKeys.bookings_boarded_at.tr(
            args: [booking.boardedAt == null ? '' : AppFormat.time(booking.boardedAt!)],
          ),
        ],
      ),
      BookingStatus.rejected => BookingNote(
        icon: Icons.cancel_outlined,
        color: AppColors.danger,
        background: AppColors.dangerLight,
        lines: [
          if (booking.rejectReason != null) LocaleKeys.bookings_reject_reason.tr(args: [booking.rejectReason!]),
        ],
        action: callAdmin,
      ),
      BookingStatus.noShow => BookingNote(
        icon: Icons.person_off_outlined,
        color: AppColors.danger,
        background: AppColors.dangerLight,
        lines: [LocaleKeys.bookings_no_show_note.tr()],
        action: callAdmin,
      ),
      BookingStatus.refundDue || BookingStatus.refunded => BookingRefundNote(booking: booking),
      BookingStatus.expired => BookingNote(
        icon: Icons.timer_off_outlined,
        color: AppColors.neutral,
        background: AppColors.neutralLight,
        lines: [LocaleKeys.payment_expired_body.tr()],
      ),
      BookingStatus.cancelled || BookingStatus.unknown => const SizedBox.shrink(),
    };
  }
}
