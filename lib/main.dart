import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'helpers/app_lang.dart';
import 'helpers/app_localization.dart';
import 'providers/file_provider.dart';
import 'views/homePage/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    myBuildContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "encfile",
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 36, 36, 36),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 36, 36, 36),
            elevation: 0,
          ),
        ),
        home: const HomePage(),
        supportedLocales: const [
          Locale('en'),
          Locale('tr'),
          Locale('ja'),
          Locale('ru'),
          Locale('ar'),
          Locale('zh'),
          Locale('de'),
          Locale('fr'),
          Locale('pt'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
