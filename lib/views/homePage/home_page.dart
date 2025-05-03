import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_lang.dart';
import '../../helpers/utils.dart';
import '../../providers/file_provider.dart';
import '../components/custom_buttom.dart';
import '../components/custom_dialog.dart';
import '../components/custom_rounded_button.dart';
import 'components/drop_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final utils = Utils();
  final btnCtrl = CustomRoundedButtonController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final tr = AppLang.langMap(context, "HomePage");
    final String t1 = AppLang.langMapToString(tr, "t1");
    final String t2 = AppLang.langMapToString(tr, "t2");
    final String b1 = AppLang.langMapToString(tr, "b1");
    final String b2 = AppLang.langMapToString(tr, "b2");
    final String b3 = AppLang.langMapToString(tr, "b3");
    final String b4 = AppLang.langMapToString(tr, "b4");
    final String b5 = AppLang.langMapToString(tr, "b5");
    final String b6 = AppLang.langMapToString(tr, "b6");
    final String b7 = AppLang.langMapToString(tr, "b7");
    final String openS = AppLang.langMapToString(tr, "openS");
    final String onlineWeb = AppLang.langMapToString(tr, "onlineWeb");

    final fileProvider = Provider.of<FileProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            InkWell(
              onTap: () => utils.url("https://github.com/bilalbaz1/encfile"),
              child: const Text(
                "ENCFILE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  letterSpacing: 2.8,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              t1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              t2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            SizedBox(
              height: size.height * 0.4,
              child: DropWidget(),
            ),
            const SizedBox(height: 15.0),
            CustomButton(
              onPressed: () async {
                final tr = AppLang.langMap(context, "HomePage");
                final String filePermissionErr1 =
                    AppLang.langMapToString(tr, "filePermissionErr1");

                bool premission = await utils.checkAndRequestPermission();
                if (premission) {
                  fileProvider.pickFilesFunc();
                } else if (context.mounted) {
                  customDialog(context, text: filePermissionErr1);
                }
              },
              text: b1,
            ),
            const SizedBox(height: 15.0),
            if (fileProvider.selectedFiles.isNotEmpty) ...[
              TextField(
                controller: fileProvider.passwordController,
                decoration: InputDecoration(
                  labelText: b2,
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              if (!fileProvider.isDecryptMode) ...[
                const SizedBox(height: 12.0),
                TextField(
                  controller: fileProvider.fileNameController,
                  decoration: InputDecoration(
                    labelText: b3,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      onPressed: () => fileProvider.cancelFunc(),
                      text: b4,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      controller: btnCtrl,
                      buttonColor: Colors.orange,
                      onPressed: () => fileProvider.isDecryptMode
                          ? (fileProvider.isDecrypted
                              ? extractFilesFunc()
                              : decryptFileFunc())
                          : encryptAndSaveFunc(),
                      text: fileProvider.isDecryptMode
                          ? (fileProvider.isDecrypted ? b5 : b6)
                          : b7,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            InkWell(
              onTap: () => utils.url("https://bilalbaz1.github.io/encfile-web"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Ionicons.globe_outline,
                    size: 25,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      "$onlineWeb\n(https://bilalbaz1.github.io/encfile-web)",
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => utils.url("https://github.com/bilalbaz1/encfile"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Ionicons.logo_github,
                    size: 25,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      "GitHub | $openS (https://github.com/bilalbaz1/encfile)",
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> extractFilesFunc() async {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    final tr = AppLang.langMap(context, "HomePage");
    final String err3 = AppLang.langMapToString(tr, "err3");
    final String success1 = AppLang.langMapToString(tr, "success1");
    final String filePermissionErr1 =
        AppLang.langMapToString(tr, "filePermissionErr1");

    bool premission = await utils.checkAndRequestPermission();

    if (premission && mounted) {
      if (fileProvider.decryptedArchive != null ||
          fileProvider.decryptedFolderName != null) {
        bool status = await fileProvider.extractFilesFunc(context);

        if (status && mounted) {
          customDialog(context, text: success1);
        } else if (mounted) {
          customDialog(context, text: err3);
        }
      }
      btnCtrl.reset();
    } else if (mounted) {
      customDialog(context, text: filePermissionErr1);
      btnCtrl.reset();
    }
  }

  Future<void> decryptFileFunc() async {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    final tr = AppLang.langMap(context, "HomePage");
    final String select1 = AppLang.langMapToString(tr, "select1");
    final String t2 = AppLang.langMapToString(tr, "t2");
    final String select2 = AppLang.langMapToString(tr, "select2");
    final String err1 = AppLang.langMapToString(tr, "err1");
    final String success1 = AppLang.langMapToString(tr, "success1");
    final String filePermissionErr1 =
        AppLang.langMapToString(tr, "filePermissionErr1");

    bool premission = await utils.checkAndRequestPermission();

    if (premission && mounted) {
      if (fileProvider.selectedFiles.isEmpty) {
        customDialog(context, text: t2);
      } else if (fileProvider.passwordController.text.isEmpty) {
        customDialog(context, text: select1);
      } else if (fileProvider.selectedFiles.first.name
              .toLowerCase()
              .split('.')
              .last !=
          "crypto") {
        customDialog(context, text: select2);
      } else {
        bool status = await fileProvider.decryptFileFunc();
        if (status && mounted) {
          customDialog(context, text: success1);
        } else if (mounted) {
          customDialog(context, text: err1);
        }
      }
      btnCtrl.reset();
    } else if (mounted) {
      customDialog(context, text: filePermissionErr1);
      btnCtrl.reset();
    }
  }

  Future<void> encryptAndSaveFunc() async {
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    final tr = AppLang.langMap(context, "HomePage");
    final String enterP = AppLang.langMapToString(tr, "enterP");
    final String fileSave2 = AppLang.langMapToString(tr, "fileSave2");

    final String filePermissionErr1 =
        AppLang.langMapToString(tr, "filePermissionErr1");

    bool premission = await utils.checkAndRequestPermission();

    if (premission && mounted) {
      if (fileProvider.selectedFiles.isEmpty ||
          fileProvider.passwordController.text.isEmpty ||
          fileProvider.fileNameController.text.isEmpty) {
        customDialog(context, text: enterP);
      } else {
        try {
          bool status = await fileProvider.encryptAndSaveFunc();
          if (status && mounted) {
            customDialog(context, text: fileSave2);
          } else if (mounted) {
            customDialog(context, text: "ERROR!");
          }
        } catch (e) {
          debugPrint('ERROR_c_197: $e');
        }
      }
      btnCtrl.reset();
    } else if (mounted) {
      customDialog(context, text: filePermissionErr1);
      btnCtrl.reset();
    }
  }
}
