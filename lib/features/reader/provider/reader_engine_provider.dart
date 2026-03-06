import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderEngineProvider extends ChangeNotifier {

  int currentPage = 0;

  double fontSize = 18;

  bool darkMode = true;

  Future<void> loadSettings() async {

    final prefs = await SharedPreferences.getInstance();

    fontSize = prefs.getDouble("reader_font") ?? 18;
    darkMode = prefs.getBool("reader_theme") ?? true;

    notifyListeners();
  }

  Future<void> changeFont(double size) async {

    fontSize = size;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("reader_font", size);

    notifyListeners();
  }

  Future<void> toggleTheme() async {

    darkMode = !darkMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("reader_theme", darkMode);

    notifyListeners();
  }

  void updatePage(int page) {

    currentPage = page;

    notifyListeners();
  }

}