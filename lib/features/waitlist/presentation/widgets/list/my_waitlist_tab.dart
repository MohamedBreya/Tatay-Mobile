import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_snack.dart';
import '../../../../../core/widgets/empty_view.dart';
import '../../../../../core/widgets/error_view.dart';
import '../../../../../core/widgets/loading_view.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/my_waitlist_cubit.dart';
import '../../cubits/my_waitlist_state.dart';
import 'waitlist_entry_card.dart';

/// The "waitlist" tab inside My bookings.
class MyWaitlistTab extends StatelessWidget {
  const MyWaitlistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyWaitlistCubit>();
    return BlocConsumer<MyWaitlistCubit, MyWaitlistState>(
      listener: (context, state) {
        if (state case MyWaitlistLoaded(leaveFailure: final failure?)) AppSnack.failure(context, failure);
      },
      builder: (context, state) => switch (state) {
        MyWaitlistLoading() => const LoadingView(),
        MyWaitlistError(:final failure) => ErrorView(failure: failure, onRetry: cubit.load),
        MyWaitlistLoaded(:final entries) when entries.isEmpty => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: EmptyView(message: LocaleKeys.waitlist_empty.tr(), icon: Icons.hourglass_empty_rounded),
        ),
        MyWaitlistLoaded(:final entries, :final leavingId) => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => WaitlistEntryCard(
              entry: entries[i],
              leaving: entries[i].id == leavingId,
              onLeave: () async {
                final left = await cubit.leave(entries[i].id);
                if (left && context.mounted) AppSnack.show(context, LocaleKeys.waitlist_left.tr());
              },
            ),
          ),
        ),
      },
    );
  }
}
