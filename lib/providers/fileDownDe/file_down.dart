import 'dart:io';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/enums.dart';

Future<bool> fileDown({
  required Archive decryptedArchive,
  required String decryptedFolderName,
  required PlatformDevice platform,
}) async {
  try {
    late Directory outputDir;

    if (platform == PlatformDevice.android) {
      outputDir =
          Directory('/storage/emulated/0/Download/$decryptedFolderName');
    } else if (platform == PlatformDevice.ios) {
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        outputDir = Directory('${downloadsDir.path}/$decryptedFolderName');
      } else {
        final documentsDir = await getApplicationDocumentsDirectory();
        outputDir = Directory('${documentsDir.path}/$decryptedFolderName');
      }
    } else {
      // macos, linux, windows
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) {
        debugPrint("fileDown -> fileDown ERROR: No directory selected");
        return false;
      }
      outputDir = Directory('$selectedDirectory/$decryptedFolderName');
    }

    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }

    for (final file in decryptedArchive) {
      if (file.isFile) {
        final filename = file.name;
        final data = file.content as List<int>;
        final outputFile = File('${outputDir.path}/$filename');
        await outputFile.writeAsBytes(data);
      }
    }

    return true;
  } catch (e) {
    debugPrint("fileDown -> fileDown ERROR(catch) : $e");
    return false;
  }
}
