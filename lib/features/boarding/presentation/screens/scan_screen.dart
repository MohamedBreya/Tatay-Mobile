import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../config/presentation/cubits/config_cubit.dart';
import '../cubits/scan_cubit.dart';
import '../cubits/scan_state.dart';
import '../widgets/camera/scan_camera_view.dart';
import '../widgets/result/scan_failure_view.dart';
import '../widgets/result/scan_success_view.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supportPhone = context.read<ConfigCubit>().config?.supportPhone;
    return BlocProvider(
      create: (_) => ScanCubit(sl()),
      child: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) => Scaffold(
          appBar: state is ScanSucceeded ? null : AppBar(title: Text(LocaleKeys.boarding_title.tr())),
          body: switch (state) {
            ScanReady() || ScanChecking() => ScanCameraView(checking: state is ScanChecking),
            ScanSucceeded(:final result) => ScanSuccessView(result: result),
            ScanFailed(:final failure) => ScanFailureView(failure: failure, supportPhone: supportPhone),
          },
        ),
      ),
    );
  }
}
