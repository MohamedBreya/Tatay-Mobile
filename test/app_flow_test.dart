import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tatay_transport/app/tatay_app.dart';
import 'package:tatay_transport/core/di/injection.dart';
import 'package:tatay_transport/core/mock/mock_behavior.dart';
import 'package:tatay_transport/features/auth/presentation/cubits/session_cubit.dart';
import 'package:tatay_transport/features/config/presentation/cubits/config_cubit.dart';
import 'package:tatay_transport/features/payment/presentation/screens/payment_screen.dart';
import 'package:tatay_transport/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:tatay_transport/features/trips/presentation/widgets/trips_list/trip_card.dart';
import 'package:tatay_transport/generated/codegen_loader.g.dart';
import 'package:tatay_transport/generated/locale_keys.g.dart';
import 'package:timezone/data/latest.dart' as tz_data;

/// The whole app on the mock backend, in Arabic: login → trips → book → payment.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    tz_data.initializeTimeZones();
    await initializeDateFormatting();
    await configureDependencies();
    sl.allowReassignment = true;
    sl.registerLazySingleton(() => MockBehavior(scenario: 'instant'));
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('log in, book a seat and land on the payment countdown', (tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('ar');
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    tester.view
      ..physicalSize = const Size(1080, 2340)
      ..devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await sl<ConfigCubit>().load();
    await sl<SessionCubit>().restore();
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        assetLoader: const CodegenLoader(),
        fallbackLocale: const Locale('ar'),
        useOnlyLangCode: true,
        saveLocale: false,
        // The locale is read at init, before the test can set it; force Arabic here only.
        startLocale: const Locale('ar'),
        child: const TatayApp(),
      ),
    );
    await settle(tester);

    // Arabic, right to left, starting on login.
    expect(Directionality.of(tester.element(find.byType(Scaffold).first)), TextDirection.rtl);
    expect(find.text(LocaleKeys.auth_login_title.tr()), findsOneWidget);

    // Client-side validation blocks a malformed phone.
    await tester.enterText(find.byType(TextFormField).at(0), '0123');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text(LocaleKeys.auth_login_button.tr()));
    await settle(tester);
    expect(find.text(LocaleKeys.errors_invalid_phone.tr()), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@tatay.app');
    await tester.tap(find.text(LocaleKeys.auth_login_button.tr()));
    await settle(tester);

    // Trips home with outbound/return tabs and trip cards.
    expect(find.text(LocaleKeys.trips_outbound.tr()), findsOneWidget);
    expect(find.byType(TripCard), findsWidgets);

    await tester.tap(find.text(LocaleKeys.trips_book.tr()).first);
    await settle(tester);
    expect(find.byType(TripDetailsScreen), findsOneWidget);

    // Pick the first stop, accept the policies, confirm.
    await tester.tap(find.text('قدام الجامع').first);
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await settle(tester);
    await tester.tap(find.byType(CheckboxListTile));
    await settle(tester);
    expect(tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value, isTrue);
    await tester.tap(find.text(LocaleKeys.trip_details_confirm_booking.tr()));
    await settle(tester);

    expect(find.byType(PaymentScreen), findsOneWidget);
    expect(find.text(LocaleKeys.payment_time_left.tr()), findsOneWidget);
    expect(find.text('01001234567'), findsOneWidget);

    // Unmount so the payment countdown timer stops before the test ends.
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
