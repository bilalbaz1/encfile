import 'dart:typed_data';
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:encfile/helpers/enums.dart';
import 'package:flutter/widgets.dart';

Future<bool> fileDown({
  required Archive decryptedArchive,
  required String decryptedFolderName,
  required PlatformDevice platform,
}) async {
  try {
    final encoder = ZipEncoder();
    final bytes = encoder.encode(decryptedArchive);

    if (bytes != null) {
      final uint8Bytes = Uint8List.fromList(bytes);
      final blob = html.Blob([uint8Bytes], 'application/zip');

      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', '$decryptedFolderName.zip')
        ..click();
      html.Url.revokeObjectUrl(url);
      return true;
    } else {
      debugPrint("fileDown -> fileDown ERROR: Zip bytes are null");
      return false;
    }
  } catch (e) {
    debugPrint("file_down_web -> fileDown ERROR(catch) : $e");
    return false;
  }
}
