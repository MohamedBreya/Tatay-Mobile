import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import 'app/tatay_app.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/cubits/session_cubit.dart';
import 'features/config/presentation/cubits/config_cubit.dart';
import 'generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  tz_data.initializeTimeZones();
  await initializeDateFormatting();
  await configureDependencies();

  unawaited(sl<ConfigCubit>().load());
  unawaited(sl<SessionCubit>().restore());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      // Arabic for any device language other than English. The locale is never forced
      // or saved: the app always follows the device language.
      fallbackLocale: const Locale('ar'),
      useOnlyLangCode: true,
      saveLocale: false,
      child: const TatayApp(),
    ),
  );
}
