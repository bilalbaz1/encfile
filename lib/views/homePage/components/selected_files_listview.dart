import 'package:encfile/helpers/utils.dart';
import 'package:encfile/providers/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedFilesListview extends StatelessWidget {
  SelectedFilesListview({super.key});

  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fileProvider.selectedFiles.length,
        itemBuilder: (context, index) {
          final file = fileProvider.selectedFiles[index];

          return ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text(file.path != null ? file.path!.split('/').last : "-"),
            subtitle: Text(
              utils.formatFileSize(
                file.size,
              ),
            ),
          );
        },
      ),
    );
  }
}
