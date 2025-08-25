import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/features/splash/presentation/splash_controller.dart';
import 'package:select_sports/providers/theme_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserState();
  }

  // Method to check user state after 2 seconds delay
  Future<void> _checkUserState() async {
    // Delay for 2 seconds
    await Future.delayed(const Duration(milliseconds: 3000));

    // Check if the widget is still mounted to avoid async gap issues
    if (!mounted) return;

    final splashController = ref.read(splashControllerProvider);

    // Directly navigate based on the logic
    splashController.redirectTo(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? Theme.of(context).primaryColorDark
          : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            fit: BoxFit.fill,
            isDarkMode
                ? Paths.lottieSplashDarkLogoJson
                : Paths.lottieSplashLogoJson,
            animate: true,
          ),
          Container(
            width: 100.w,
            color: Colors.transparent,
            height: 50,
          ),
          Text(
            "Select Sports",
            style: AppTextStyles.body.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? AppColors.lightText : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}
