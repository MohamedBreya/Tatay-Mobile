import 'package:flutter/material.dart';

import '../../../../../core/widgets/status_chip.dart';
import '../../../data/models/booking_enums.dart';
import 'booking_status_style.dart';

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final style = bookingStatusStyle(status);
    return StatusChip(label: style.label, foreground: style.fg, background: style.bg);
  }
}
