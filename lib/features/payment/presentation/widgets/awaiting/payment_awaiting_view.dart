import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/countdown_card.dart';
import '../../../../../generated/locale_keys.g.dart';

import '../../cubits/payment_state.dart';
import 'payment_amount_card.dart';
import 'payment_upload_section.dart';

class PaymentAwaitingView extends StatelessWidget {
  const PaymentAwaitingView({super.key, required this.state});

  final PaymentAwaiting state;

  @override
  Widget build(BuildContext context) {
    final booking = state.booking;
    final payment = booking.payment;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CountdownCard(label: LocaleKeys.payment_time_left.tr(), secondsLeft: state.secondsLeft),
        const SizedBox(height: 12),
        PaymentAmountCard(amount: payment?.amount ?? booking.amount, accountNumber: payment?.accountNumber ?? ''),
        const SizedBox(height: 20),
        PaymentUploadSection(upload: state.upload),
      ],
    );
  }
}
