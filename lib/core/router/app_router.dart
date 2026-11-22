import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/account/presentation/screens/change_password_screen.dart';
import '../../features/auth/presentation/cubits/session_cubit.dart';
import '../../features/auth/presentation/cubits/session_state.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/boarding/presentation/screens/scan_screen.dart';
import '../../features/bookings/presentation/screens/booking_details_screen.dart';
import '../../features/bookings/presentation/screens/my_bookings_screen.dart';
import '../../features/home/presentation/screens/home_shell_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/trips/presentation/screens/trip_details_screen.dart';
import '../../features/trips/presentation/screens/trips_screen.dart';
import '../../features/waitlist/presentation/screens/waitlist_offer_screen.dart';
import 'app_routes.dart';
import 'stream_listenable.dart';

abstract final class AppRouter {
  static GoRouter create(SessionCubit session) => GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: StreamListenable(session.stream),
    redirect: (context, state) => _redirect(session.state, state),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (_, s) => VerifyEmailScreen(
          email: s.uri.queryParameters['email'] ?? '',
          cooldown: int.tryParse(s.uri.queryParameters['cooldown'] ?? '') ?? 0,
        ),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, s) => ResetPasswordScreen(
          email: s.uri.queryParameters['email'] ?? '',
          cooldown: int.tryParse(s.uri.queryParameters['cooldown'] ?? '') ?? 0,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShellScreen(shell: shell),
        branches: [
          _tab(AppRoutes.trips, const TripsScreen()),
          _tab(AppRoutes.bookings, const MyBookingsScreen()),
          _tab(AppRoutes.notifications, const NotificationsScreen()),
          _tab(AppRoutes.account, const AccountScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.tripDetails,
        builder: (_, s) => TripDetailsScreen(tripId: s.pathParameters['tripId']!),
      ),
      GoRoute(
        path: AppRoutes.bookingDetails,
        builder: (_, s) => BookingDetailsScreen(bookingId: s.pathParameters['bookingId']!),
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (_, s) => PaymentScreen(bookingId: s.pathParameters['bookingId']!),
      ),
      GoRoute(path: AppRoutes.scan, builder: (_, _) => const ScanScreen()),
      GoRoute(
        path: AppRoutes.waitlistOffer,
        builder: (_, s) => WaitlistOfferScreen(entryId: s.pathParameters['entryId']!),
      ),
      GoRoute(path: AppRoutes.changePassword, builder: (_, _) => const ChangePasswordScreen()),
    ],
  );

  static StatefulShellBranch _tab(String path, Widget screen) => StatefulShellBranch(
    routes: [GoRoute(path: path, builder: (_, _) => screen)],
  );

  /// Session gates: restoring → splash; logged out → auth screens only;
  /// unverified email → OTP screen only; logged in → never the auth screens.
  static String? _redirect(SessionState session, GoRouterState state) {
    final location = state.matchedLocation;
    final onAuthPage = AppRoutes.authPaths.contains(location);
    return switch (session) {
      SessionUnknown() => location == AppRoutes.splash ? null : AppRoutes.splash,
      SessionUnauthenticated() => onAuthPage ? null : AppRoutes.login,
      SessionUnverified(:final user) => location == AppRoutes.verifyEmail ? null : AppRoutes.verifyEmailFor(user.email),
      SessionAuthenticated() => onAuthPage || location == AppRoutes.splash ? AppRoutes.trips : null,
    };
  }
}
