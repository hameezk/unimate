import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    dialogTheme:
        const DialogTheme(backgroundColor: Color.fromRGBO(45, 41, 74, 1)),
    scaffoldBackgroundColor: const Color.fromRGBO(26, 24, 48, 1),
    canvasColor: const Color.fromRGBO(45, 41, 74, 1),
    indicatorColor: Colors.white70,
    bottomAppBarColor: Colors.white30,
    errorColor: Colors.white54,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(
        primary: Colors.white54, secondary: Colors.white38),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    cardColor: const Color.fromRGBO(45, 41, 74, 1),
  );

  static final lightTheme = ThemeData(
    dialogTheme: const DialogTheme(backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.indigo[300],
    indicatorColor: Colors.black87,
    bottomAppBarColor: Colors.white54,
    errorColor: Colors.indigo[300],
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(
        primary: Colors.black, secondary: Colors.black54),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
  );
}
