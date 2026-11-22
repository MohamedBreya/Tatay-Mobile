import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'proof_image_data_source.dart';

class ProofImageDeviceDataSource implements ProofImageDataSource {
  ProofImageDeviceDataSource(this._picker);

  final ImagePicker _picker;

  static const _maxBytes = 5 * 1024 * 1024;

  @override
  Future<File?> pick(ProofImageOrigin origin) async {
    final picked = await _picker.pickImage(
      source: origin == ProofImageOrigin.camera ? ImageSource.camera : ImageSource.gallery,
    );
    if (picked == null) return null;
    // Always re-encode as JPEG: the upload declares image/jpeg, and screenshots can be large PNGs.
    for (final (quality, width) in [(85, 1600), (65, 1280), (45, 1024)]) {
      final file = await _compress(picked.path, quality, width);
      if (file != null && await file.length() <= _maxBytes) return file;
    }
    return File(picked.path);
  }

  Future<File?> _compress(String path, int quality, int minWidth) async {
    final target = '${Directory.systemTemp.path}/proof_${DateTime.now().microsecondsSinceEpoch}.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      target,
      quality: quality,
      minWidth: minWidth,
      minHeight: minWidth,
      format: CompressFormat.jpeg,
    );
    return result == null ? null : File(result.path);
  }
}
