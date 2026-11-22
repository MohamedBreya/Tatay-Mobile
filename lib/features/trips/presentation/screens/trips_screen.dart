import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/trip_enums.dart';
import '../cubits/trips_cubit.dart';
import '../widgets/trips_list/trips_tab.dart';

/// Home tab: outbound and return trips in two tabs, grouped by day.
class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.trips_title.tr()),
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.trips_outbound.tr()),
              Tab(text: LocaleKeys.trips_return.tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(create: (_) => TripsCubit(sl(), Direction.outbound)..load(), child: const TripsTab()),
            BlocProvider(create: (_) => TripsCubit(sl(), Direction.returnTrip)..load(), child: const TripsTab()),
          ],
        ),
      ),
    );
  }
}
