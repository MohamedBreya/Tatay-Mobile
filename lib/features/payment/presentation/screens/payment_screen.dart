import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../generated/locale_keys.g.dart';
import '../cubits/payment_cubit.dart';
import '../cubits/payment_state.dart';
import '../widgets/awaiting/payment_awaiting_view.dart';
import '../widgets/result/payment_closed_view.dart';
import '../widgets/result/payment_submitted_view.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with WidgetsBindingObserver {
  late final PaymentCubit _cubit = PaymentCubit(sl(), sl(), bookingId: widget.bookingId)..load();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _cubit.onResumed();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(LocaleKeys.payment_title.tr())),
        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) => switch (state) {
            PaymentLoading() => const LoadingView(),
            PaymentError(:final failure) => ErrorView(failure: failure, onRetry: _cubit.load),
            PaymentAwaiting() => PaymentAwaitingView(state: state),
            PaymentSubmitted(:final booking) => PaymentSubmittedView(booking: booking),
            PaymentExpired() => const PaymentClosedView(expired: true),
            PaymentNotPayable(:final booking) => PaymentClosedView(expired: false, bookingId: booking.id),
          },
        ),
      ),
    );
  }
}
