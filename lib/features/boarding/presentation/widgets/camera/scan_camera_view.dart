import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../cubits/scan_cubit.dart';
import 'camera_error_view.dart';
import 'scan_frame_overlay.dart';

/// Live camera with a frame. While [checking], the code is being verified on the server.
/// Owns its camera controller, so the camera turns off whenever a result is shown.
class ScanCameraView extends StatefulWidget {
  const ScanCameraView({super.key, required this.checking});

  final bool checking;

  @override
  State<ScanCameraView> createState() => _ScanCameraViewState();
}

class _ScanCameraViewState extends State<ScanCameraView> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.qrCode]);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScanCubit>();
    final checking = widget.checking;
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _controller,
          onDetect: (capture) {
            final raw = capture.barcodes.map((b) => b.rawValue).whereType<String>().firstOrNull;
            if (raw != null) cubit.scan(raw);
          },
          errorBuilder: (context, error) => const CameraErrorView(),
        ),
        const ScanFrameOverlay(),
        PositionedDirectional(
          start: 24,
          end: 24,
          bottom: 48,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.scrim, borderRadius: BorderRadius.circular(12)),
            child: checking
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textOnDark),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        LocaleKeys.boarding_checking.tr(),
                        style: AppStyles.body.copyWith(color: AppColors.textOnDark),
                      ),
                    ],
                  )
                : Text(
                    LocaleKeys.boarding_hint.tr(),
                    style: AppStyles.body.copyWith(color: AppColors.textOnDark),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ],
    );
  }
}
