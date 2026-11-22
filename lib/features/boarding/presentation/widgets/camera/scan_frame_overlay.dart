import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

/// A square frame in the middle of the camera view.
class ScanFrameOverlay extends StatelessWidget {
  const ScanFrameOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.scannerFrame, width: 3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
