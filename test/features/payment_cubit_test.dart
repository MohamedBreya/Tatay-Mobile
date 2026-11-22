import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tatay_transport/core/mock/mock_api_error.dart';
import 'package:tatay_transport/core/network/api_failure_mapper.dart';
import 'package:tatay_transport/core/network/result.dart';
import 'package:tatay_transport/features/bookings/data/repositories/bookings_repository.dart';
import 'package:tatay_transport/features/payment/data/datasources/proof_image_data_source.dart';
import 'package:tatay_transport/features/payment/data/repositories/payment_repository.dart';
import 'package:tatay_transport/features/payment/presentation/cubits/payment_cubit.dart';
import 'package:tatay_transport/features/payment/presentation/cubits/payment_state.dart';

import '../helpers/fixtures.dart';

import 'dart:io';

class _Bookings extends Mock implements BookingsRepository {}

class _Payment extends Mock implements PaymentRepository {}

void main() {
  late _Bookings bookings;
  late _Payment payment;

  setUpAll(() {
    registerFallbackValue(File('x'));
    registerFallbackValue(ProofImageOrigin.gallery);
  });

  setUp(() {
    bookings = _Bookings();
    payment = _Payment();
  });

  PaymentCubit build() => PaymentCubit(bookings, payment, bookingId: 'booking-1');

  blocTest<PaymentCubit, PaymentState>(
    'countdown starts from the server seconds_left and ticks down',
    build: build,
    setUp: () =>
        when(() => bookings.getBooking('booking-1')).thenAnswer((_) async => Success(bookingFixture(secondsLeft: 120))),
    act: (c) async {
      await c.load();
      await Future<void>.delayed(const Duration(milliseconds: 2100));
    },
    verify: (c) => expect((c.state as PaymentAwaiting).secondsLeft, 118),
  );

  blocTest<PaymentCubit, PaymentState>(
    'seconds_left = 0 from the server means expired',
    build: build,
    setUp: () =>
        when(() => bookings.getBooking('booking-1')).thenAnswer((_) async => Success(bookingFixture(secondsLeft: 0))),
    act: (c) => c.load(),
    expect: () => [isA<PaymentLoading>(), isA<PaymentExpired>()],
  );

  blocTest<PaymentCubit, PaymentState>(
    'upload moves to submitted (pending_review)',
    build: build,
    setUp: () {
      when(() => bookings.getBooking('booking-1')).thenAnswer((_) async => Success(bookingFixture()));
      when(() => payment.pickProof(ProofImageOrigin.gallery)).thenAnswer((_) async => File('proof.jpg'));
      when(() => payment.uploadProof('booking-1', any()))
          .thenAnswer((_) async => Success(bookingFixture(status: 'pending_review', secondsLeft: null)));
    },
    act: (c) async {
      await c.load();
      await c.pickAndUpload(ProofImageOrigin.gallery);
    },
    verify: (c) => expect(c.state, isA<PaymentSubmitted>()),
  );

  blocTest<PaymentCubit, PaymentState>(
    'HOLD_EXPIRED on upload shows the expired screen (T3)',
    build: build,
    setUp: () {
      when(() => bookings.getBooking('booking-1')).thenAnswer((_) async => Success(bookingFixture(secondsLeft: 1)));
      when(() => payment.pickProof(any())).thenAnswer((_) async => File('proof.jpg'));
      when(() => payment.uploadProof('booking-1', any()))
          .thenAnswer((_) async => Failure(ApiFailureMapper.map(MockApiError.server(409, 'HOLD_EXPIRED', 'خلصت'))));
    },
    act: (c) async {
      await c.load();
      await c.pickAndUpload(ProofImageOrigin.camera);
    },
    verify: (c) => expect(c.state, isA<PaymentExpired>()),
  );

  blocTest<PaymentCubit, PaymentState>(
    'cancelling the picker changes nothing',
    build: build,
    setUp: () {
      when(() => bookings.getBooking('booking-1')).thenAnswer((_) async => Success(bookingFixture()));
      when(() => payment.pickProof(any())).thenAnswer((_) async => null);
    },
    act: (c) async {
      await c.load();
      await c.pickAndUpload(ProofImageOrigin.gallery);
    },
    verify: (c) {
      expect(c.state, isA<PaymentAwaiting>());
      verifyNever(() => payment.uploadProof(any(), any()));
    },
  );
}
