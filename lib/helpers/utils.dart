import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'enums.dart';

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

  PlatformDevice platformDevice() {
    if (kIsWeb) {
      return PlatformDevice.web;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformDevice.android;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return PlatformDevice.ios;
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return PlatformDevice.windows;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return PlatformDevice.linux;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return PlatformDevice.macOS;
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}
