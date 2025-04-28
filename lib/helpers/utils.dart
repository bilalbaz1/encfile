import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return "$bytes B";
    } else if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    } else {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }
  }

  Future<void> url(String url) async {
    try {
      if (!await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppBrowserView,
      )) {
        debugPrint("err: url");
      }
    } catch (e) {
      //
    }
  }
}
