import 'package:easy_localization/easy_localization.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../generated/locale_keys.g.dart';
import '../config/app_env.dart';

/// Display formatting. The API sends UTC and piasters; the app shows Cairo time
/// (12-hour, ص/م) and pounds. No money math happens here, only display.
abstract final class AppFormat {
  static tz.Location get _cairo => tz.getLocation(AppEnv.cairoTimeZone);

  static String get _locale => Intl.getCurrentLocale();

  static tz.TZDateTime cairo(DateTime utc) => tz.TZDateTime.from(utc, _cairo);

  /// Calendar day in Cairo, used to group trips by day.
  static DateTime cairoDay(DateTime utc) {
    final local = cairo(utc);
    return DateTime(local.year, local.month, local.day);
  }

  static String money(int piasters) {
    final pounds = piasters / 100;
    final pattern = piasters % 100 == 0 ? '#,##0' : '#,##0.00';
    return LocaleKeys.common_money.tr(args: [_latin(NumberFormat(pattern, _locale).format(pounds))]);
  }

  static String time(DateTime utc) => _latin(DateFormat('h:mm a', _locale).format(cairo(utc)));

  /// "النهارده", "بكرة", or a weekday with date.
  static String day(DateTime utc) {
    final target = cairoDay(utc);
    final today = cairoDay(DateTime.now().toUtc());
    final diff = target.difference(today).inDays;
    if (diff == 0) return LocaleKeys.common_today.tr();
    if (diff == 1) return LocaleKeys.common_tomorrow.tr();
    return _latin(DateFormat('EEEE d MMMM', _locale).format(target));
  }

  static String dayAndTime(DateTime utc) => '${day(utc)} · ${time(utc)}';

  /// mm:ss for countdowns driven by the server's `seconds_left`.
  static String countdown(int seconds) {
    final safe = seconds < 0 ? 0 : seconds;
    String two(int n) => n.toString().padLeft(2, '0');
    return LocaleKeys.common_countdown.tr(args: [two(safe ~/ 60), two(safe % 60)]);
  }

  /// One digit style everywhere: Arabic dates would otherwise use ٠-٩ while phone numbers,
  /// prices and counts use 0-9 on the same screen.
  static String _latin(String text) => text.replaceAllMapped(
        RegExp('[٠-٩]'),
        (m) => '${m[0]!.codeUnitAt(0) - 0x0660}',
      );
}
