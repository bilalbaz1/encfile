import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/utils.dart';
import '../../../providers/file_provider.dart';

class DecryptedFilesListview extends StatelessWidget {
  DecryptedFilesListview({super.key});
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fileProvider.decryptedArchive!.files.length,
        itemBuilder: (context, index) {
          final file = fileProvider.decryptedArchive!.files[index];
          if (!file.isFile) {
            return const SizedBox.shrink();
          }
          return ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text(file.name),
            subtitle: Text(
              utils.formatFileSize(file.size),
            ),
          );
        },
      ),
    );
  }
}
