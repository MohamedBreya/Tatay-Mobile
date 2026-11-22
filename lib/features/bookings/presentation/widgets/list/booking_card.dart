import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../data/models/booking_model.dart';
import '../shared/booking_trip_summary.dart';
import 'booking_card_footer.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onReturn});

  final BookingModel booking;

  /// Called after coming back from the details page, to refresh the list.
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          await context.push(AppRoutes.bookingDetailsFor(booking.id));
          onReturn();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookingTripSummary(booking: booking),
              const Divider(height: 24),
              BookingCardFooter(booking: booking),
            ],
          ),
        ),
      ),
    );
  }
}
