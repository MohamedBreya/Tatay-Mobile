import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../data/models/notification_target_model.dart';

/// Opens the screen a notification points to (deep link). Unknown targets open the list.
abstract final class NotificationTargetRouter {
  static void open(GoRouter router, NotificationTargetModel target) {
    final path = switch (target.screen) {
      TargetScreen.booking when target.bookingId != null => AppRoutes.bookingDetailsFor(target.bookingId!),
      TargetScreen.trip when target.tripId != null => AppRoutes.tripDetailsFor(target.tripId!),
      TargetScreen.waitlistOffer when target.waitlistEntryId != null => AppRoutes.waitlistOfferFor(
        target.waitlistEntryId!,
      ),
      _ => null,
    };
    if (path != null) {
      router.push(path);
    } else {
      router.go(AppRoutes.notifications);
    }
  }
}
