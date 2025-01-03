import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);

  void toggleTheme(BuildContext context) {
    if (state == ThemeMode.system) {
      // Check the platform brightness
      final brightness = MediaQuery.of(context).platformBrightness;
      state = brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Toggle between light and dark
      state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
