import 'package:flutter/widgets.dart';

import 'app_localization.dart';

late final BuildContext? myBuildContext;

class AppLang {
  static Map<String, dynamic> langMap(BuildContext? context, String key) {
    try {
      if (context == null) {
        if (myBuildContext != null) {
          final translate =
              AppLocalizations.of(myBuildContext!).localization[key];
          return translate;
        } else {
          debugPrint(
            " ******* AppLang Error -> langMap : c_17",
          );
          return {};
        }
      } else {
        final translate = AppLocalizations.of(context).localization[key];
        return translate;
      }
    } catch (e) {
      debugPrint(" ******* AppLang -> langMap Error(catch) : c_26");
      return {};
    }
  }

  static String langMapToString(
    Map<String, dynamic> mapTranslate,
    String key,
  ) {
    try {
      if (myBuildContext != null) {
        try {
          var str1 = mapTranslate[key];
          if (str1 != null) {
            return str1;
          } else {
            debugPrint(
              " ******* AppLang Error -> langMapToString : c_43",
            );
            return "-";
          }
        } catch (e) {
          debugPrint(
            " ******* AppLang Error -> langMapToString : c_49",
          );
          return "-";
        }
      } else {
        debugPrint(
          " ******* AppLang Error -> langMapToString : c_55",
        );
        return "-";
      }
    } catch (e) {
      debugPrint(" ******* AppLang -> langMapToString Error(catch) : c_60");
      return "-";
    }
  }
}
