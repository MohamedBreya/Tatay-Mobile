import 'dart:io';

enum ProofImageOrigin { gallery, camera }

/// Gets the transfer screenshot from the device, ready to upload (JPEG under 5 MB).
abstract interface class ProofImageDataSource {
  /// Returns null when the passenger cancels the picker.
  Future<File?> pick(ProofImageOrigin origin);
}
