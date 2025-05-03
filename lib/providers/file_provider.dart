import 'fileSaverEnc/file_saver.dart'
    if (dart.library.html) 'fileSaverEnc/file_saver_web.dart';
import 'fileDownDe/file_down.dart'
    if (dart.library.html) 'fileDownDe/file_down_web.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import '../helpers/utils.dart';

class FileProvider extends ChangeNotifier {
  final utils = Utils();

  List<PlatformFile> selectedFiles = [];
  TextEditingController passwordController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  bool isDragging = false;
  bool isDecryptMode = false;
  bool isDecrypted = false;
  Archive? decryptedArchive;
  String? decryptedFolderName;

  Future<bool> encryptAndSaveFunc() async {
    try {
      final encoder = ZipEncoder();
      final archive = Archive();

      for (var file in selectedFiles) {
        final bytes = file.bytes;
        if (bytes == null) continue;
        final fileName = file.name;
        archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
      }

      final zipBytes = encoder.encode(archive);

      if (zipBytes == null) {
        throw "zip_error_56";
      }

      final key = encrypt.Key.fromUtf8(
        passwordController.text.padRight(32, '0').substring(0, 32),
      );
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encrypted = encrypter.encryptBytes(zipBytes, iv: iv);
      final outputBytes = [...iv.bytes, ...encrypted.bytes];

      final platform = utils.platformDevice();

      bool status = await saveFile(
        platform: platform,
        fileNameController: fileNameController,
        outputBytes: outputBytes,
        selectedFiles: selectedFiles,
        passwordController: passwordController,
        notifyListeners: notifyListeners,
      );

      if (status) {
        selectedFiles.clear();
        passwordController.clear();
        isDecrypted = false;
        decryptedArchive = null;
        decryptedFolderName = null;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('file_provider -> encryptAndSaveFunc ERROR(catch) : $e');
      return false;
    }
  }

  Future<bool> decryptFileFunc() async {
    try {
      final file = selectedFiles.first;

      final encryptedBytes = file.bytes;
      if (encryptedBytes == null || encryptedBytes.isEmpty) {
        throw "c_empty_file";
      }

      final ivBytes = encryptedBytes.sublist(0, 16);
      final dataBytes = encryptedBytes.sublist(16);

      final key = encrypt.Key.fromUtf8(
        passwordController.text.padRight(32, '0').substring(0, 32),
      );
      final iv = encrypt.IV(ivBytes);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final decrypted =
          encrypter.decryptBytes(encrypt.Encrypted(dataBytes), iv: iv);

      if (decrypted.isEmpty) {
        throw 'c_pass';
      }

      final archive = ZipDecoder().decodeBytes(decrypted);
      if (archive.isEmpty) {
        throw 'c_zip_empty';
      }

      String fileName = file.name;
      String folderName = fileName.substring(0, fileName.length - 7);

      isDecrypted = true;
      decryptedArchive = archive;
      decryptedFolderName = folderName;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('file_provider -> decryptFileFunc ERROR(catch) : $e');
      return false;
    }
  }

  Future<bool> extractFilesFunc(BuildContext context) async {
    try {
      final platform = utils.platformDevice();

      bool downloadStatus = await fileDown(
        decryptedArchive: decryptedArchive!,
        decryptedFolderName: decryptedFolderName ?? "encDfile",
        platform: platform,
      );

      if (downloadStatus && context.mounted) {
        selectedFiles.clear();
        passwordController.clear();
        isDecrypted = false;
        decryptedArchive = null;
        decryptedFolderName = null;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('file_provider -> extractFilesFunc ERROR(catch) : $e');

      return false;
    }
  }

  Future<void> pickFilesFunc() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true, // web için, true yapıldı
      );

      if (result != null) {
        selectedFiles = result.files;
        final file = selectedFiles.first;

        if (selectedFiles.length == 1 &&
            file.name.toLowerCase().endsWith('.crypto')) {
          isDecryptMode = true;
        } else {
          isDecryptMode = false;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('file_provider -> pickFilesFunc ERROR(catch) : $e');
    }
  }

  void cancelFunc() {
    selectedFiles = [];
    notifyListeners();
  }

  Future<void> onDragDoneFunc(DropDoneDetails detail) async {
    try {
      if (kIsWeb) return; // web de calismiyor!!!

      for (var e in detail.files) {
        final length = await e.length();
        final bytes = await e.readAsBytes();

        selectedFiles.add(
          PlatformFile(
            name: e.name,
            path: e.path,
            size: length,
            bytes: bytes,
          ),
        );
      }

      isDecrypted = false;
      decryptedArchive = null;
      decryptedFolderName = null;

      final file = selectedFiles.first;
      if (selectedFiles.length == 1 &&
          file.name.toLowerCase().endsWith('.crypto')) {
        isDecryptMode = true;
      } else {
        isDecryptMode = false;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('file_provider -> onDragDoneFunc ERROR(catch) : $e');
    }
  }

  void onDragEnteredFunc(DropEventDetails detail) {
    isDragging = true;
    notifyListeners();
  }

  void onDragExitedFunc(DropEventDetails detail) {
    isDragging = false;
    notifyListeners();
  }
}
