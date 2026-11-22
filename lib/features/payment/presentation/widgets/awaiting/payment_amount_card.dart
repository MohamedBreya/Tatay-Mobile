import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_format.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/utils/app_snack.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/section_card.dart';
import '../../../../../generated/locale_keys.g.dart';

/// The amount and the InstaPay/wallet number, both from the server's booking.
class PaymentAmountCard extends StatelessWidget {
  const PaymentAmountCard({super.key, required this.amount, required this.accountNumber});

  final int amount;
  final String accountNumber;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(LocaleKeys.payment_amount.tr(), style: AppStyles.bodySecondary),
          Text(AppFormat.money(amount), style: AppStyles.headline.copyWith(color: AppColors.primaryDark)),
          const Divider(height: 28),
          Text(LocaleKeys.payment_transfer_to.tr(), style: AppStyles.bodySecondary),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: SelectableText(accountNumber, style: AppStyles.accountNumber, textDirection: TextDirection.ltr),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: AppTheme.inlineButtonSize),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: accountNumber));
                  if (context.mounted) {
                    AppSnack.show(context, LocaleKeys.common_copied.tr());
                  }
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(LocaleKeys.common_copy.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
