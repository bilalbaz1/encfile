import 'dart:html' as html;

import 'package:flutter/widgets.dart';
import 'dart:typed_data';
import '../../helpers/enums.dart';

Future<bool> saveFile({
  required PlatformDevice platform,
  required fileNameController,
  required outputBytes,
  required selectedFiles,
  required passwordController,
  required notifyListeners,
}) async {
  try {
    //* web
    //! eski final blob = html.Blob([outputBytes]);

    final bytes = Uint8List.fromList(outputBytes);
    final blob = html.Blob([bytes], 'application/octet-stream');

    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', '${fileNameController.text}.crypto')
      ..click();

    html.Url.revokeObjectUrl(url);

    return true;
  } catch (e) {
    debugPrint("file_saver_web -> saveFile ERROR(catch) : $e");
    return false;
  }
}
