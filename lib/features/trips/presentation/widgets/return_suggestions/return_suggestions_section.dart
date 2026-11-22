import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/return_suggestions_cubit.dart';
import '../../cubits/return_suggestions_state.dart';
import 'return_suggestion_tile.dart';

/// "Coming back the same day?" after an outbound booking. Hidden when there is nothing to show.
class ReturnSuggestionsSection extends StatelessWidget {
  const ReturnSuggestionsSection({super.key, required this.outboundTripId});

  final String outboundTripId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReturnSuggestionsCubit(sl())..load(outboundTripId),
      child: BlocBuilder<ReturnSuggestionsCubit, ReturnSuggestionsState>(
        builder: (context, state) => switch (state) {
          ReturnSuggestionsLoaded(:final trips) when trips.isNotEmpty => SectionCard(
            title: LocaleKeys.payment_return_suggestions.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(LocaleKeys.payment_return_suggestions_hint.tr(), style: AppStyles.caption),
                for (final trip in trips) ReturnSuggestionTile(trip: trip),
              ],
            ),
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
