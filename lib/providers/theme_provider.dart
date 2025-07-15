import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(Brightness platformBrightness)
      : super(platformBrightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light);

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

final themeProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  throw UnimplementedError(); // initialized later in main()
});

