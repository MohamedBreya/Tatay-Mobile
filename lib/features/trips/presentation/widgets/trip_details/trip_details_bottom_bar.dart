import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/action_status.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/models/trip_enums.dart';
import '../../cubits/trip_details_cubit.dart';
import '../../cubits/trip_details_state.dart';

/// "Confirm booking", "Join the waitlist" or "Booking closed", with the last error above it.
class TripDetailsBottomBar extends StatelessWidget {
  const TripDetailsBottomBar({super.key, required this.state, required this.offerMinutes});

  final TripDetailsLoaded state;
  final int offerMinutes;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TripDetailsCubit>();
    final availability = state.trip.availability;
    final loading = state.submit is ActionInProgress;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.submit case ActionFailed(:final failure)) ...[
              FailureBanner(failure: failure),
              const SizedBox(height: 12),
            ],
            if (availability == Availability.full) ...[
              Text(LocaleKeys.trip_details_waitlist_note.tr(args: ['$offerMinutes']), style: AppStyles.caption),
              const SizedBox(height: 8),
            ],
            switch (availability) {
              Availability.available => LoadingButton(
                label: LocaleKeys.trip_details_confirm_booking.tr(),
                isLoading: loading,
                onPressed: state.canSubmit ? cubit.book : null,
              ),
              Availability.full => LoadingButton(
                label: LocaleKeys.trip_details_confirm_waitlist.tr(),
                outlined: true,
                isLoading: loading,
                onPressed: state.canSubmit ? cubit.joinWaitlist : null,
              ),
              Availability.closed ||
              Availability.unknown => FilledButton(onPressed: null, child: Text(LocaleKeys.trips_closed.tr())),
            },
          ],
        ),
      ),
    );
  }
}
