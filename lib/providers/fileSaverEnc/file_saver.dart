import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../helpers/enums.dart';
import "dart:io" as io;

Future<bool> saveFile({
  required PlatformDevice platform,
  required fileNameController,
  required outputBytes,
  required selectedFiles,
  required passwordController,
  required notifyListeners,
}) async {
  try {
    if (platform == PlatformDevice.windows ||
        platform == PlatformDevice.linux ||
        platform == PlatformDevice.macOS) {
      String? savePath = await FilePicker.platform.saveFile(
        fileName: '${fileNameController.text}.crypto',
      );

      if (savePath != null) {
        final outputFile = io.File(savePath);
        await outputFile.writeAsBytes(outputBytes);

        selectedFiles.clear();
        passwordController.clear();
        fileNameController.clear();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } else if (platform == PlatformDevice.android ||
        platform == PlatformDevice.ios) {
      //* android , ios
      io.Directory? downloadsDirectory;
      if (platform == PlatformDevice.android) {
        downloadsDirectory = io.Directory('/storage/emulated/0/Download');
      } else if (platform == PlatformDevice.ios) {
        downloadsDirectory = await getDownloadsDirectory();
      }

      if (downloadsDirectory != null) {
        final outputFile = io.File(
            '${downloadsDirectory.path}/${fileNameController.text}.crypto');
        await outputFile.writeAsBytes(outputBytes);
        return true;
      } else {
        debugPrint("ERROR_c_102");
        return false;
      }
    } else {
      throw "unsupported platform";
    }
  } catch (e) {
    debugPrint("file_saver -> saveFile ERROR(catch) : $e");
    return false;
  }
}
