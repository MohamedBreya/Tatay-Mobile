import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/action_status.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/countdown_card.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/waitlist_offer_cubit.dart';
import '../../cubits/waitlist_offer_state.dart';
import '../shared/waitlist_trip_summary.dart';

/// Trip, stop, amount and a 5-minute countdown, with "book and pay now" / "no thanks".
class OfferOpenView extends StatelessWidget {
  const OfferOpenView({super.key, required this.state});

  final WaitlistOfferOpen state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WaitlistOfferCubit>();
    final entry = state.entry;
    final busy = state.action is ActionInProgress;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(LocaleKeys.waitlist_offer_title.tr(), style: AppStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        CountdownCard(label: LocaleKeys.waitlist_offer_time_left.tr(), secondsLeft: state.secondsLeft, urgentBelow: 60),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WaitlistTripSummary(entry: entry),
              const Divider(height: 24),
              Row(
                children: [
                  Text(LocaleKeys.common_seats.plural(entry.seats), style: AppStyles.body),
                  const Spacer(),
                  if (entry.offerAmount != null) Text(AppFormat.money(entry.offerAmount!), style: AppStyles.price),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (state.action case ActionFailed(:final failure)) ...[
          FailureBanner(failure: failure),
          const SizedBox(height: 12),
        ],
        LoadingButton(label: LocaleKeys.waitlist_accept.tr(), isLoading: busy, onPressed: cubit.accept),
        const SizedBox(height: 10),
        LoadingButton(
          label: LocaleKeys.waitlist_decline.tr(),
          outlined: true,
          isLoading: busy,
          onPressed: cubit.decline,
        ),
      ],
    );
  }
}
