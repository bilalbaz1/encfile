import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../helpers/app_lang.dart';
import '../../helpers/utils.dart';
import '../../providers/file_provider.dart';
import '../components/custom_buttom.dart';
import 'components/drop_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
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

    final fileProvider = Provider.of<FileProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              InkWell(
                onTap: () => utils.url("https://github.com/bilalbaz1/encfile"),
                child: const Text(
                  "ENCFILE",
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
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                t2,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12.0),
              DropWidget(),
              const SizedBox(height: 12.0),
              CustomButton(
                onPressed: () => fileProvider.pickFilesFunc(),
                text: b1,
              ),
              const SizedBox(height: 10.0),
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
                  const SizedBox(height: 10),
                  TextField(
                    controller: fileProvider.fileNameController,
                    decoration: InputDecoration(
                      labelText: b3,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
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
                        buttonColor: Colors.orange,
                        onPressed: () => fileProvider.isDecryptMode
                            ? (fileProvider.isDecrypted
                                ? fileProvider.extractFilesFunc(context)
                                : fileProvider.decryptFileFunc(context))
                            : fileProvider.encryptAndSaveFunc(context),
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
                onTap: () => utils.url("https://github.com/bilalbaz1/encfile"),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Ionicons.logo_github,
                      size: 25,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        "GitHub | $openS",
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
      ),
    );
  }
}
