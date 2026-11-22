import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_format.dart';
import '../../../../../core/widgets/info_row.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/booking_model.dart';
import '../shared/booking_trip_summary.dart';

class BookingInfoCard extends StatelessWidget {
  const BookingInfoCard({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final plate = booking.trip.vehiclePlateNumber;
    return SectionCard(
      child: Column(
        children: [
          BookingTripSummary(booking: booking),
          const Divider(height: 24),
          InfoRow(icon: Icons.place_outlined, label: LocaleKeys.bookings_stop.tr(), value: booking.stop.name),
          InfoRow(
            icon: Icons.schedule_rounded,
            label: LocaleKeys.bookings_stop_time.tr(),
            value: AppFormat.time(booking.stop.scheduledAt),
          ),
          InfoRow(
            icon: Icons.event_seat_outlined,
            label: LocaleKeys.bookings_seats.tr(),
            value: LocaleKeys.common_seats.plural(booking.seats),
          ),
          InfoRow(
            icon: Icons.payments_outlined,
            label: LocaleKeys.bookings_amount.tr(),
            value: AppFormat.money(booking.amount),
          ),
          if (plate != null)
            InfoRow(icon: Icons.airport_shuttle_outlined, label: LocaleKeys.bookings_vehicle.tr(), value: plate),
        ],
      ),
    );
  }
}
