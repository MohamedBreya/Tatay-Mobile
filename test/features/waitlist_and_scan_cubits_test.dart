import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tatay_transport/core/mock/mock_api_error.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/result.dart';
import 'package:tatay_transport/features/boarding/data/models/scan_result_model.dart';
import 'package:tatay_transport/features/boarding/data/repositories/boarding_repository.dart';
import 'package:tatay_transport/features/boarding/presentation/cubits/scan_cubit.dart';
import 'package:tatay_transport/features/boarding/presentation/cubits/scan_state.dart';
import 'package:tatay_transport/features/waitlist/data/repositories/waitlist_repository.dart';
import 'package:tatay_transport/features/waitlist/presentation/cubits/waitlist_offer_cubit.dart';
import 'package:tatay_transport/features/waitlist/presentation/cubits/waitlist_offer_state.dart';

import '../helpers/fixtures.dart';

class _Waitlist extends Mock implements WaitlistRepository {}

class _Boarding extends Mock implements BoardingRepository {}

void main() {
  group('waitlist offer', () {
    late _Waitlist repo;
    setUp(() => repo = _Waitlist());

    blocTest<WaitlistOfferCubit, WaitlistOfferState>(
      'an entry that is no longer offered shows "offer expired"',
      build: () => WaitlistOfferCubit(repo, entryId: 'entry-1'),
      setUp: () =>
          when(() => repo.getEntry('entry-1'))
              .thenAnswer((_) async => Success(entryFixture(status: 'expired', secondsLeft: null))),
      act: (c) => c.load(),
      expect: () => [isA<WaitlistOfferLoading>(), isA<WaitlistOfferClosed>()],
    );

    blocTest<WaitlistOfferCubit, WaitlistOfferState>(
      'accept returns a booking to pay',
      build: () => WaitlistOfferCubit(repo, entryId: 'entry-1'),
      setUp: () {
        when(() => repo.getEntry('entry-1')).thenAnswer((_) async => Success(entryFixture()));
        when(() => repo.accept('entry-1')).thenAnswer((_) async => Success(bookingFixture()));
      },
      act: (c) async {
        await c.load();
        await c.accept();
      },
      verify: (c) => expect((c.state as WaitlistOfferAccepted).booking.id, 'booking-1'),
    );

    blocTest<WaitlistOfferCubit, WaitlistOfferState>(
      'OFFER_EXPIRED while accepting closes the offer',
      build: () => WaitlistOfferCubit(repo, entryId: 'entry-1'),
      setUp: () {
        when(() => repo.getEntry('entry-1')).thenAnswer((_) async => Success(entryFixture()));
        when(() => repo.accept('entry-1'))
            .thenAnswer((_) async => Failure(ApiFailureMapper.map(MockApiError.server(409, 'OFFER_EXPIRED', ''))));
      },
      act: (c) async {
        await c.load();
        await c.accept();
      },
      verify: (c) => expect(c.state, isA<WaitlistOfferClosed>()),
    );
  });

  group('scan', () {
    late _Boarding repo;
    setUp(() => repo = _Boarding());

    blocTest<ScanCubit, ScanState>(
      'repeated detections of the same code send one request',
      build: () => ScanCubit(repo),
      setUp: () => when(() => repo.scan('TATAY-VEH-1')).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return const Success(
          ScanResultModel(
            bookingId: 'b',
            seats: 1,
            passengerName: 'محمد',
            stopName: 'المدرسة',
            vehiclePlateNumber: 'ن ق ل 1234',
            alreadyBoarded: false,
          ),
        );
      }),
      act: (c) async {
        await Future.wait([c.scan('TATAY-VEH-1'), c.scan('TATAY-VEH-1'), c.scan('TATAY-VEH-1')]);
      },
      expect: () => [isA<ScanChecking>(), isA<ScanSucceeded>()],
      verify: (_) => verify(() => repo.scan('TATAY-VEH-1')).called(1),
    );
  });
}
