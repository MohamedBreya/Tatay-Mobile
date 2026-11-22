import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/result.dart';
import '../../data/repositories/boarding_repository.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit(this._repository) : super(const ScanReady());

  final BoardingRepository _repository;

  /// The camera reports the same code many times a second; only the first one counts.
  Future<void> scan(String qrToken) async {
    if (state is! ScanReady || qrToken.trim().isEmpty) return;
    emit(const ScanChecking());
    final result = await _repository.scan(qrToken);
    emit(switch (result) {
      Success(:final data) => ScanSucceeded(data),
      Failure(:final failure) => ScanFailed(failure),
    });
  }

  void retry() => emit(const ScanReady());
}
