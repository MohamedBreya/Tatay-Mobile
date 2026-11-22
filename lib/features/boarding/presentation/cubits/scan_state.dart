import '../../../../core/network/api_failure.dart';
import '../../data/models/scan_result_model.dart';

sealed class ScanState {
  const ScanState();
}

/// Camera on, waiting for a QR code.
final class ScanReady extends ScanState {
  const ScanReady();
}

final class ScanChecking extends ScanState {
  const ScanChecking();
}

/// Boarded (or already boarded): show the big green screen to the driver.
final class ScanSucceeded extends ScanState {
  const ScanSucceeded(this.result);

  final ScanResultModel result;
}

/// QR_INVALID, NO_BOOKING, WRONG_VEHICLE, OUTSIDE_WINDOW, PAYMENT_NOT_CONFIRMED, or network.
final class ScanFailed extends ScanState {
  const ScanFailed(this.failure);

  final ApiFailure failure;
}
