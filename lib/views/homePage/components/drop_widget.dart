import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/app_lang.dart';
import '../../../helpers/utils.dart';
import '../../../providers/file_provider.dart';
import '../../components/custom_dialog.dart';
import 'decrypted_files_listview.dart';
import 'selected_files_listview.dart';

class DropWidget extends StatelessWidget {
  DropWidget({super.key});
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    final tr = AppLang.langMap(context, "HomePage");
    final String select3 = AppLang.langMapToString(tr, "select3");

    final fileProvider = Provider.of<FileProvider>(context);

    return InkWell(
      onTap: () async {
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
      child: DropTarget(
        onDragDone: (detail) => fileProvider.onDragDoneFunc(detail),
        onDragEntered: (detail) => fileProvider.onDragEnteredFunc(detail),
        onDragExited: (detail) => fileProvider.onDragExitedFunc(detail),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: fileProvider.isDragging
                ? Colors.blue.withOpacity(0.2)
                : Color.fromRGBO(15, 15, 15, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (fileProvider.selectedFiles.isEmpty) ...[
                Icon(
                  Icons.folder,
                  size: 80,
                  color: Colors.blue.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  select3,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ] else if (fileProvider.isDecryptMode &&
                  fileProvider.isDecrypted &&
                  fileProvider.decryptedArchive != null) ...[
                DecryptedFilesListview(),
              ] else ...[
                SelectedFilesListview(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
