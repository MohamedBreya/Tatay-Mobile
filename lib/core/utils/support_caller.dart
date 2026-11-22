import 'package:url_launcher/url_launcher.dart';

/// Opens the dialer with the admin's number from `/config`.
abstract final class SupportCaller {
  static Future<void> call(String phone) => launchUrl(Uri(scheme: 'tel', path: phone));
}
