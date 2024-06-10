import 'package:flutter/widgets.dart';

class DarkModeConfig extends ChangeNotifier {
  bool isDarkMode = true;

  void toggleIsDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
