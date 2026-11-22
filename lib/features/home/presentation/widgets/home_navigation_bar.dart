import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../notifications/presentation/cubits/notifications_cubit.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({super.key, required this.currentIndex, required this.onSelect});

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final unread = context.select<NotificationsCubit, int>((c) => c.state.unreadCount);
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onSelect,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.directions_bus_outlined),
          selectedIcon: const Icon(Icons.directions_bus_rounded),
          label: LocaleKeys.nav_trips.tr(),
        ),
        NavigationDestination(
          icon: const Icon(Icons.confirmation_number_outlined),
          selectedIcon: const Icon(Icons.confirmation_number_rounded),
          label: LocaleKeys.nav_bookings.tr(),
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text('$unread'),
            child: const Icon(Icons.notifications_outlined),
          ),
          selectedIcon: const Icon(Icons.notifications_rounded),
          label: LocaleKeys.nav_notifications.tr(),
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: LocaleKeys.nav_account.tr(),
        ),
      ],
    );
  }
}
