import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/api_failure.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/failure_message.dart';
import '../../../../../core/utils/support_caller.dart';
import '../../../../../core/widgets/result_message.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/scan_cubit.dart';

/// The BR-40 reason from the server, "scan again", and "call the admin".
class ScanFailureView extends StatelessWidget {
  const ScanFailureView({super.key, required this.failure, this.supportPhone});

  final ApiFailure failure;
  final String? supportPhone;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ResultMessage(
          icon: Icons.error_outline_rounded,
          color: AppColors.danger,
          background: AppColors.dangerLight,
          title: LocaleKeys.boarding_failed_title.tr(),
          body: failureMessage(failure),
        ),
        FilledButton.icon(
          onPressed: context.read<ScanCubit>().retry,
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: Text(LocaleKeys.boarding_scan_again.tr()),
        ),
        if (supportPhone != null) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => SupportCaller.call(supportPhone!),
            icon: const Icon(Icons.call_outlined),
            label: Text(LocaleKeys.common_call_admin.tr()),
          ),
        ],
      ],
    );
  }
}
