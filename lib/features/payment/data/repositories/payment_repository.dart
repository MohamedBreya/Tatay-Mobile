import 'dart:io';

import '../../../../core/network/idempotent_call.dart';
import '../../../../core/network/result.dart';
import '../../../bookings/data/datasources/bookings_data_source.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../datasources/proof_image_data_source.dart';

class PaymentRepository {
  PaymentRepository(this._images, this._bookings);

  final ProofImageDataSource _images;
  final BookingsDataSource _bookings;

  Future<File?> pickProof(ProofImageOrigin origin) => _images.pick(origin);

  /// Moves the booking to `pending_review`. Retries on a dropped connection reuse the key.
  Future<Result<BookingModel>> uploadProof(String bookingId, File image) =>
      idempotentCall((key) => _bookings.uploadPaymentProof(bookingId, key, image));
}
