import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tatay_transport/core/utils/app_format.dart';
import 'package:timezone/data/latest.dart' as tz_data;

void main() {
  setUpAll(() async {
    tz_data.initializeTimeZones();
    await initializeDateFormatting();
  });

  test('UTC is shown in Cairo time, 12-hour with ص/م and Latin digits', () {
    Intl.defaultLocale = 'ar';
    // 04:30Z is 06:30 in Cairo (UTC+2 in November).
    expect(AppFormat.time(DateTime.utc(2026, 11, 23, 4, 30)), '6:30 ص');
    expect(AppFormat.time(DateTime.utc(2026, 11, 23, 12, 30)), '2:30 م');
  });

  test('Cairo calendar day, not UTC day, groups late-night trips', () {
    // 22:30Z on the 22nd is 00:30 on the 23rd in Cairo.
    expect(AppFormat.cairoDay(DateTime.utc(2026, 11, 22, 22, 30)), DateTime(2026, 11, 23));
  });
}
