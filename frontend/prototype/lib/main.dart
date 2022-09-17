import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prototype/screens/home/_main_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prototype/styles/general.dart';

/// idee von https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(RootClass());
  });
}

class RootClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        scaffoldBackgroundColor: GeneralStyle.getLightGray(),
        primaryColor: GeneralStyle.getUglyGreen(),
        focusColor: GeneralStyle.getUglyGreen(),
        colorScheme: ColorScheme(
            onPrimary: Colors.white,
            onError: Colors.red,
            error: Colors.red,
            onSurface: Colors.black,
            primary: GeneralStyle.getUglyGreen(),
            surface: GeneralStyle.getUglyGreen(),
            secondary: GeneralStyle.getDarkGray(),
            onSecondary: GeneralStyle.getDarkGray(),
            brightness: Brightness.light,
            background: GeneralStyle.getLightGray(),
            onBackground: GeneralStyle.getLightGray()),
        appBarTheme: appBarStyle(),
        cardTheme: CardTheme(
          shadowColor: Colors.transparent,
        ),
      ),
      home: Home(),
    );
  }

  AppBarTheme appBarStyle() {
    return const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(color: Color.fromARGB(167, 59, 59, 59)
          //  fontFamily: GoogleFonts.changa(),
          ),
    );
  }

  static Ink customButtonStyle(String text) {
    return Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.fromARGB(255, 36, 0, 107),
            Color.fromARGB(175, 36, 0, 107)
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(
            minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
