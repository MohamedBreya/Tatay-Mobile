import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/notifications_cubit.dart';
import '../cubits/notifications_state.dart';
import '../widgets/list/notification_tile.dart';
import '../widgets/push/notification_target_router.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.notifications_title.tr())),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) => switch (state) {
          NotificationsLoading() => const LoadingView(),
          NotificationsError(:final failure) => ErrorView(failure: failure, onRetry: cubit.load),
          NotificationsLoaded(:final items) when items.isEmpty => RefreshIndicator(
            onRefresh: cubit.refresh,
            child: EmptyView(message: LocaleKeys.notifications_empty.tr(), icon: Icons.notifications_none_rounded),
          ),
          NotificationsLoaded(:final items, :final loadingMore) => RefreshIndicator(
            onRefresh: cubit.refresh,
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (n) {
                if (n.metrics.extentAfter < 200) cubit.loadMore();
                return false;
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length + (loadingMore ? 1 : 0),
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, i) => i == items.length
                    ? const LoadingView()
                    : NotificationTile(
                        notification: items[i],
                        onTap: () {
                          cubit.markRead(items[i].id);
                          NotificationTargetRouter.open(GoRouter.of(context), items[i].target);
                        },
                      ),
              ),
            ),
          ),
        },
      ),
    );
  }
}
