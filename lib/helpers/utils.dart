import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;

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

  Future<bool> checkAndRequestPermission() async {
    try {
      PlatformDevice platform = platformDevice();
      if (platform == PlatformDevice.android ||
          platform == PlatformDevice.ios) {
        PermissionStatus status = await Permission.storage.status;

        if (status.isGranted) {
          return true;
        } else if (status.isDenied) {
          openAppSettings();
          return false;
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
          return false;
        } else if (status.isRestricted) {
          openAppSettings();
          return false;
        } else if (status.isLimited) {
          //! openAppSettings();
          return true;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      debugPrint("Utils -> checkAndRequestPermissions ERROR(catch) : $e");
      return false;
    }
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }
}
