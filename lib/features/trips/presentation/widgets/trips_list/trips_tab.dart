import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/empty_view.dart';
import '../../../../../core/widgets/error_view.dart';
import '../../../../../core/widgets/loading_view.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/trips_cubit.dart';
import '../../cubits/trips_state.dart';
import 'trips_list_view.dart';

/// One direction's list. Kept alive so switching tabs does not reload.
class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cubit = context.read<TripsCubit>();
    return BlocBuilder<TripsCubit, TripsState>(
      builder: (context, state) => switch (state) {
        TripsLoading() => const LoadingView(),
        TripsError(:final failure) => ErrorView(failure: failure, onRetry: cubit.load),
        TripsLoaded(:final trips) when trips.isEmpty => RefreshIndicator(
          onRefresh: cubit.refresh,
          child: EmptyView(message: LocaleKeys.trips_empty.tr(), icon: Icons.directions_bus_outlined),
        ),
        TripsLoaded() => TripsListView(byDay: state.byDay, onRefresh: cubit.refresh),
      },
    );
  }
}
