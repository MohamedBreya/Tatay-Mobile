import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/state/action_status.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/widgets/failure_banner.dart';
import '../../../../../core/widgets/loading_button.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../data/datasources/proof_image_data_source.dart';
import '../../cubits/payment_cubit.dart';

/// The "I paid" step: the button only works with a screenshot (US-3.2).
class PaymentUploadSection extends StatelessWidget {
  const PaymentUploadSection({super.key, required this.upload});

  final ActionStatus upload;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PaymentCubit>();
    final uploading = upload is ActionInProgress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(LocaleKeys.payment_steps.tr(), style: AppStyles.body),
        const SizedBox(height: 16),
        if (upload case ActionFailed(:final failure)) ...[FailureBanner(failure: failure), const SizedBox(height: 12)],
        if (uploading) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Text(LocaleKeys.payment_uploading.tr(), style: AppStyles.caption, textAlign: TextAlign.center),
          const SizedBox(height: 12),
        ],
        LoadingButton(
          label: LocaleKeys.payment_upload_gallery.tr(),
          icon: Icons.upload_file_rounded,
          isLoading: uploading,
          onPressed: () => cubit.pickAndUpload(ProofImageOrigin.gallery),
        ),
        const SizedBox(height: 10),
        LoadingButton(
          label: LocaleKeys.payment_take_photo.tr(),
          icon: Icons.photo_camera_outlined,
          outlined: true,
          isLoading: uploading,
          onPressed: () => cubit.pickAndUpload(ProofImageOrigin.camera),
        ),
      ],
    );
  }
}
