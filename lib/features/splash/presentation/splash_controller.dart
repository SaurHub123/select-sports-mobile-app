import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/features/auth/presentation/login_page.dart';
import 'package:select_sports/features/main/presentation/main_screen.dart';
import 'package:select_sports/features/onboarding/presentation/onboarding_screen.dart';
import 'package:select_sports/features/profile/presentation/edit_profile_screen.dart';
import 'package:select_sports/features/splash/data/splash_repository.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(ref.read(splashRepositoryProvider));
});

class SplashController {
  final SplashRepository splashRepository;

  SplashController(this.splashRepository);

  Future<void> redirectTo(BuildContext context) async {
    // Check if the user has already visited the app
    final hasVisited = await splashRepository.hasAlreadyVisited();

    if (!hasVisited) {
      await splashRepository.setAlreadyVisited(true);
      // Navigate to onboarding screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
              (route) => false,
        );
      }
      // if (context.mounted) {
      //   Navigator.pushNamed(context, '/onboarding');
      // }
      return;
    }

    // Validate token only if the user has already visited
    final isTokenValid = await splashRepository.checkTokenValidity();

    if (isTokenValid) {
      // Navigate to home screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (route) => false,
        );
      }
    } else {
      // Navigate to login screen
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
