import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../helpers/app_lang.dart';
import '../views/components/custom_dialog.dart';

class FileProvider extends ChangeNotifier {
  List<File> selectedFiles = [];
  TextEditingController passwordController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  bool isDragging = false;
  bool isDecryptMode = false;
  bool isDecrypted = false;
  Archive? decryptedArchive;
  String? decryptedFolderName;

  Future<void> encryptAndSaveFunc(BuildContext context) async {
    final tr = AppLang.langMap(context, "HomePage");
    final String enterP = AppLang.langMapToString(tr, "enterP");
    final String fileSave1 = AppLang.langMapToString(tr, "fileSave1");
    final String fileSave2 = AppLang.langMapToString(tr, "fileSave2");

    if (selectedFiles.isEmpty ||
        passwordController.text.isEmpty ||
        fileNameController.text.isEmpty) {
      if (context.mounted) {
        customDialog(
          context,
          text: enterP,
        );
      }

      return;
    }

    try {
      // ZIP arşivi oluştur
      final encoder = ZipEncoder();
      final archive = Archive();

      // Dosyaları ZIP'e ekle
      for (var file in selectedFiles) {
        final bytes = await file.readAsBytes();
        final fileName = file.path.split('/').last;
        archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
      }

      // ZIP'i byte dizisine dönüştür
      final zipBytes = encoder.encode(archive);
      if (zipBytes == null) {
        throw "zip_error_56";
      }

      // IV oluştur ve şifrele
      final key = encrypt.Key.fromUtf8(
        passwordController.text.padRight(32, '0').substring(0, 32),
      );
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

      final encrypted = encrypter.encryptBytes(zipBytes, iv: iv);

      // IV ve şifrelenmiş veriyi birleştir
      final outputBytes = [...iv.bytes, ...encrypted.bytes];

      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        String? savePath = await FilePicker.platform.saveFile(
          dialogTitle: fileSave1,
          fileName: '${fileNameController.text}.crypto',
        );

        if (savePath != null) {
          final outputFile = File(savePath);
          await outputFile.writeAsBytes(outputBytes);
          if (context.mounted) {
            customDialog(
              context,
              text: "$fileSave2: ${outputFile.path}",
            );
          }

          selectedFiles.clear();
          passwordController.clear();
          fileNameController.clear();
          notifyListeners();
        }
      } else {
        //android, ios
        Directory? downloadsDirectory;

        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          downloadsDirectory = await getDownloadsDirectory();
        }

        if (downloadsDirectory != null) {
          final outputFile = File(
              '${downloadsDirectory.path}/${fileNameController.text}.crypto');
          await outputFile.writeAsBytes(encrypted.bytes);
        } else {
          debugPrint("ERROR_c_102");
        }
      }
    } catch (e) {
      debugPrint('ERROR_c_124: $e');
    }
  }

  Future<void> decryptFileFunc(BuildContext context) async {
    final tr = AppLang.langMap(context, "HomePage");
    final String select1 = AppLang.langMapToString(tr, "select1");
    final String select2 = AppLang.langMapToString(tr, "select2");
    final String err1 = AppLang.langMapToString(tr, "err1");
    final String err2 = AppLang.langMapToString(tr, "err2");

    if (selectedFiles.isEmpty || passwordController.text.isEmpty) {
      if (context.mounted) {
        customDialog(
          context,
          text: select1,
        );
      }

      return;
    }

    try {
      final file = selectedFiles.first;
      if (!file.path.toLowerCase().endsWith('.crypto')) {
        if (context.mounted) {
          customDialog(
            context,
            text: select2,
          );
        }

        return;
      }

      final encryptedBytes = await file.readAsBytes();
      if (encryptedBytes.isEmpty) {
        throw Exception('c_empty_file');
      }

      // İlk 16 byte IV, geri kalanı şifrelenmiş veri
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
        if (context.mounted) {
          customDialog(
            context,
            text: err1,
          );
        }

        throw 'c_pass';
      }

      // ZIP'i çöz
      try {
        final archive = ZipDecoder().decodeBytes(decrypted);
        if (archive.isEmpty) {
          if (context.mounted) {
            customDialog(
              context,
              text: err2,
            );
          }

          throw 'c_zip_empty';
        }

        // Şifreli dosyanın adını al ve .crypto uzantısını kaldır
        String fileName = file.path.split('/').last;
        String folderName = fileName.substring(0, fileName.length - 7);

        isDecrypted = true;
        decryptedArchive = archive;
        decryptedFolderName = folderName;
        notifyListeners();
      } catch (e) {
        debugPrint('ERROR_c_197: $e');
      }
    } catch (e) {
      debugPrint('ERROR_c_200: $e');
    }
  }

  Future<void> extractFilesFunc(BuildContext context) async {
    final tr = AppLang.langMap(context, "HomePage");
    final String err3 = AppLang.langMapToString(tr, "err3");
    final String success1 = AppLang.langMapToString(tr, "success1");

    if (decryptedArchive == null || decryptedFolderName == null) return;

    try {
      Directory outputDir;

      if (Platform.isAndroid) {
        outputDir =
            Directory('/storage/emulated/0/Download/$decryptedFolderName');
      } else if (Platform.isIOS) {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          outputDir = Directory('${downloadsDir.path}/$decryptedFolderName');
        } else {
          // iOS'da eğer Downloads bulunamazsa Documents'a kaydet
          final documentsDir = await getApplicationDocumentsDirectory();
          outputDir = Directory('${documentsDir.path}/$decryptedFolderName');
        }
      } else {
        // macOS, Windows, Linux
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory == null) {
          // Kullanıcı seçim yapmadıysa işlemi iptal et
          if (context.mounted) {
            customDialog(context, text: err3);
          }
          return;
        }
        outputDir = Directory('$selectedDirectory/$decryptedFolderName');
      }

      if (!await outputDir.exists()) {
        await outputDir.create(recursive: true);
      }

      for (final file in decryptedArchive!) {
        if (file.isFile) {
          final filename = file.name;
          final data = file.content as List<int>;
          final outputFile = File('${outputDir.path}/$filename');
          await outputFile.writeAsBytes(data);
        }
      }

      if (context.mounted) {
        customDialog(
          context,
          text: "$success1: ${outputDir.path}",
        );
      }

      selectedFiles.clear();
      passwordController.clear();
      isDecrypted = false;
      decryptedArchive = null;
      decryptedFolderName = null;
      notifyListeners();
    } catch (e) {
      debugPrint('ERROR_c_238: $e');
    }
  }

  Future<void> pickFilesFunc() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      selectedFiles = result.paths.map((path) => File(path!)).toList();
      final file = selectedFiles.first;

      if (selectedFiles.length == 1 &&
          file.path.toLowerCase().endsWith('.crypto')) {
        // .crypto uzantılı dosya atıldı.

        isDecryptMode = true;
      } else {
        isDecryptMode = false;
      }
      notifyListeners();
    }
  }

  void cancelFunc() {
    selectedFiles = [];
    notifyListeners();
  }

  void onDragDoneFunc(DropDoneDetails detail) {
    selectedFiles = detail.files.map((e) => File(e.path)).toList();
    isDecrypted = false;
    decryptedArchive = null;
    decryptedFolderName = null;

    final file = selectedFiles.first;
    if (selectedFiles.length == 1 &&
        file.path.toLowerCase().endsWith('.crypto')) {
      // .crypto uzantılı dosya atıldı.

      isDecryptMode = true;
    } else {
      isDecryptMode = false;
    }
    notifyListeners();
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
