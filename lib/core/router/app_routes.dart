/// Every path in the app, in one place.
abstract final class AppRoutes {
  // Auth
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  // Tabs (bottom navigation)
  static const trips = '/trips';
  static const bookings = '/bookings';
  static const notifications = '/notifications';
  static const account = '/account';

  // Full-screen pages above the tabs
  static const tripDetails = '/trip/:tripId';
  static const bookingDetails = '/booking/:bookingId';
  static const payment = '/booking/:bookingId/pay';
  static const scan = '/scan';
  static const waitlistOffer = '/waitlist/:entryId/offer';
  static const changePassword = '/change-password';

  static const authPaths = {login, register, verifyEmail, forgotPassword, resetPassword};

  static String verifyEmailFor(String email, {int cooldown = 0}) =>
      Uri(path: verifyEmail, queryParameters: {'email': email, 'cooldown': '$cooldown'}).toString();

  static String resetPasswordFor(String email, {int cooldown = 0}) =>
      Uri(path: resetPassword, queryParameters: {'email': email, 'cooldown': '$cooldown'}).toString();

  static String tripDetailsFor(String tripId) => '/trip/$tripId';

  static String bookingDetailsFor(String bookingId) => '/booking/$bookingId';

  static String paymentFor(String bookingId) => '/booking/$bookingId/pay';

  static String waitlistOfferFor(String entryId) => '/waitlist/$entryId/offer';
}
