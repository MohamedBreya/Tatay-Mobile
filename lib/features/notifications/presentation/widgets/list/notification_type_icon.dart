import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

/// Icon per notification type (N1..N10). Unknown types get a generic bell.
class NotificationTypeIcon extends StatelessWidget {
  const NotificationTypeIcon({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      'booking_confirmed' => (Icons.check_circle_rounded, AppColors.success),
      'booking_expired' => (Icons.timer_off_rounded, AppColors.neutral),
      'payment_rejected' => (Icons.cancel_rounded, AppColors.danger),
      'trip_reminder' => (Icons.alarm_rounded, AppColors.info),
      'trip_changed' => (Icons.edit_calendar_rounded, AppColors.warning),
      'trip_cancelled' || 'trip_not_operated' => (Icons.event_busy_rounded, AppColors.danger),
      'refunded' => (Icons.currency_exchange_rounded, AppColors.info),
      'booking_moved' => (Icons.swap_horiz_rounded, AppColors.warning),
      'waitlist_offer' => (Icons.event_seat_rounded, AppColors.success),
      _ => (Icons.notifications_rounded, AppColors.primary),
    };
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withValues(alpha: 0.12),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
