import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/data/models/app_config_model.dart';
import '../../../data/models/trip_enums.dart';
import '../../cubits/trip_details_cubit.dart';
import '../../cubits/trip_details_state.dart';
import 'existing_reservation_card.dart';
import 'policies_card.dart';
import 'seats_selector.dart';
import 'stops_section.dart';
import 'trip_header_card.dart';

class TripDetailsBody extends StatelessWidget {
  const TripDetailsBody({super.key, required this.state, required this.config});

  final TripDetailsLoaded state;
  final AppConfigModel? config;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TripDetailsCubit>();
    final trip = state.trip;
    final hasReservation = trip.myBookingId != null || trip.hasActiveWaitlist;
    final open = !hasReservation && trip.availability != Availability.closed;
    final maxSeats = config?.maxSeatsPerBooking ?? 2;
    final selectableSeats = trip.availability == Availability.available
        ? max(1, min(maxSeats, trip.availableSeats))
        : maxSeats;
    const gap = SizedBox(height: 12);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TripHeaderCard(trip: trip),
        gap,
        if (hasReservation) ...[ExistingReservationCard(trip: trip), gap],
        StopsSection(trip: trip, selectedStopId: state.stopId, onSelect: open ? cubit.selectStop : null),
        if (open) ...[
          gap,
          SeatsSelector(
            seats: min(state.seats, selectableSeats),
            maxSeats: selectableSeats,
            total: trip.seatPrice * min(state.seats, selectableSeats),
            onChanged: cubit.setSeats,
          ),
          gap,
          PoliciesCard(policies: config?.policies, agreed: state.agreed, onChanged: cubit.setAgreed),
        ],
      ],
    );
  }
}
