import 'dart:typed_data';

class UploadImageParams {
  final String fileName;
  final Uint8List bytes;

  UploadImageParams({required this.fileName, required this.bytes});
}
