import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../waitlist/presentation/cubits/my_waitlist_cubit.dart';
import '../../../waitlist/presentation/widgets/list/my_waitlist_tab.dart';
import '../../data/models/booking_enums.dart';
import '../cubits/my_bookings_cubit.dart';
import '../widgets/list/bookings_tab.dart';

/// Current and past bookings, and the waitlist entries.
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.bookings_title.tr()),
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.bookings_active.tr()),
              Tab(text: LocaleKeys.bookings_past.tr()),
              Tab(text: LocaleKeys.bookings_waitlist.tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (_) => MyBookingsCubit(sl(), BookingScope.active)..load(),
              child: BookingsTab(emptyMessage: LocaleKeys.bookings_empty_active.tr()),
            ),
            BlocProvider(
              create: (_) => MyBookingsCubit(sl(), BookingScope.past)..load(),
              child: BookingsTab(emptyMessage: LocaleKeys.bookings_empty_past.tr()),
            ),
            BlocProvider(create: (_) => MyWaitlistCubit(sl())..load(), child: const MyWaitlistTab()),
          ],
        ),
      ),
    );
  }
}
