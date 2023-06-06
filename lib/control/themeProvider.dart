import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  String? theme;

  Future<void> fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();
    theme = prefs.getString('theme');
    notifyListeners();
  }
}