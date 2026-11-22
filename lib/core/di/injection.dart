import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/account/data/datasources/account_data_source.dart';
import '../../features/account/data/datasources/account_mock_data_source.dart';
import '../../features/account/data/datasources/account_remote_data_source.dart';
import '../../features/account/data/repositories/account_repository.dart';
import '../../features/auth/data/datasources/auth_data_source.dart';
import '../../features/auth/data/datasources/auth_mock_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubits/session_cubit.dart';
import '../../features/boarding/data/datasources/boarding_data_source.dart';
import '../../features/boarding/data/datasources/boarding_mock_data_source.dart';
import '../../features/boarding/data/datasources/boarding_remote_data_source.dart';
import '../../features/boarding/data/repositories/boarding_repository.dart';
import '../../features/bookings/data/datasources/bookings_data_source.dart';
import '../../features/bookings/data/datasources/bookings_mock_data_source.dart';
import '../../features/bookings/data/datasources/bookings_remote_data_source.dart';
import '../../features/bookings/data/repositories/bookings_repository.dart';
import '../../features/config/data/datasources/config_data_source.dart';
import '../../features/config/data/datasources/config_mock_data_source.dart';
import '../../features/config/data/datasources/config_remote_data_source.dart';
import '../../features/config/data/repositories/config_repository.dart';
import '../../features/config/presentation/cubits/config_cubit.dart';
import '../../features/notifications/data/datasources/notifications_data_source.dart';
import '../../features/notifications/data/datasources/notifications_mock_data_source.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/datasources/push_data_source.dart';
import '../../features/notifications/data/datasources/push_disabled_data_source.dart';
import '../../features/notifications/data/datasources/push_firebase_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/data/repositories/push_repository.dart';
import '../../features/notifications/presentation/cubits/notifications_cubit.dart';
import '../../features/payment/data/datasources/proof_image_data_source.dart';
import '../../features/payment/data/datasources/proof_image_device_data_source.dart';
import '../../features/payment/data/repositories/payment_repository.dart';
import '../../features/trips/data/datasources/trips_data_source.dart';
import '../../features/trips/data/datasources/trips_mock_data_source.dart';
import '../../features/trips/data/datasources/trips_remote_data_source.dart';
import '../../features/trips/data/repositories/trips_repository.dart';
import '../../features/waitlist/data/datasources/waitlist_data_source.dart';
import '../../features/waitlist/data/datasources/waitlist_mock_data_source.dart';
import '../../features/waitlist/data/datasources/waitlist_remote_data_source.dart';
import '../../features/waitlist/data/repositories/waitlist_repository.dart';
import '../config/app_env.dart';
import '../mock/mock_behavior.dart';
import '../mock/mock_database.dart';
import '../network/dio_factory.dart';
import '../session/session_events.dart';
import '../storage/token_storage.dart';

/// The service locator. Screens create their cubits with `Cubit(sl(), ...)`.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core
  sl
    ..registerLazySingleton(() => TokenStorage(const FlutterSecureStorage()))
    ..registerLazySingleton(SessionEvents.new)
    ..registerLazySingleton<Dio>(() => DioFactory.create(storage: sl(), events: sl()));
  await sl<TokenStorage>().load();

  // Data sources: the only place that knows whether we run on mocks or the real API.
  if (AppEnv.useMock) {
    sl
      ..registerLazySingleton(MockBehavior.new)
      ..registerLazySingleton(() => MockDatabase(sl()))
      ..registerLazySingleton<AuthDataSource>(() => AuthMockDataSource(sl()))
      ..registerLazySingleton<AccountDataSource>(() => AccountMockDataSource(sl()))
      ..registerLazySingleton<ConfigDataSource>(() => ConfigMockDataSource(sl()))
      ..registerLazySingleton<TripsDataSource>(() => TripsMockDataSource(sl()))
      ..registerLazySingleton<BookingsDataSource>(() => BookingsMockDataSource(sl()))
      ..registerLazySingleton<WaitlistDataSource>(() => WaitlistMockDataSource(sl()))
      ..registerLazySingleton<BoardingDataSource>(() => BoardingMockDataSource(sl()))
      ..registerLazySingleton<NotificationsDataSource>(() => NotificationsMockDataSource(sl()));
  } else {
    sl
      ..registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource(sl()))
      ..registerLazySingleton<AccountDataSource>(() => AccountRemoteDataSource(sl()))
      ..registerLazySingleton<ConfigDataSource>(() => ConfigRemoteDataSource(sl()))
      ..registerLazySingleton<TripsDataSource>(() => TripsRemoteDataSource(sl()))
      ..registerLazySingleton<BookingsDataSource>(() => BookingsRemoteDataSource(sl()))
      ..registerLazySingleton<WaitlistDataSource>(() => WaitlistRemoteDataSource(sl()))
      ..registerLazySingleton<BoardingDataSource>(() => BoardingRemoteDataSource(sl()))
      ..registerLazySingleton<NotificationsDataSource>(() => NotificationsRemoteDataSource(sl()));
  }
  sl
    ..registerLazySingleton<PushDataSource>(
      () => AppEnv.pushEnabled ? PushFirebaseDataSource() : PushDisabledDataSource(),
    )
    ..registerLazySingleton<ProofImageDataSource>(() => ProofImageDeviceDataSource(ImagePicker()));

  // Repositories
  sl
    ..registerLazySingleton(() => AuthRepository(sl(), sl()))
    ..registerLazySingleton(() => AccountRepository(sl(), sl()))
    ..registerLazySingleton(() => ConfigRepository(sl()))
    ..registerLazySingleton(() => TripsRepository(sl()))
    ..registerLazySingleton(() => BookingsRepository(sl()))
    ..registerLazySingleton(() => PaymentRepository(sl(), sl()))
    ..registerLazySingleton(() => WaitlistRepository(sl()))
    ..registerLazySingleton(() => BoardingRepository(sl()))
    ..registerLazySingleton(() => NotificationsRepository(sl()))
    ..registerLazySingleton(() => PushRepository(sl(), sl()));

  // App-wide cubits (provided at the root of the widget tree)
  sl
    ..registerLazySingleton(() => SessionCubit(sl(), sl(), sl(), sl()))
    ..registerLazySingleton(() => ConfigCubit(sl()))
    ..registerLazySingleton(() => NotificationsCubit(sl(), sl()));
}
