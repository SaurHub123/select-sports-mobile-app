import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/providers/responsive_provider.dart';

import '../../providers/theme_provider.dart';

class CustomButtons {
  static Widget fullWidthFilledButton({
    required String buttonText,
    required WidgetRef ref,
    required Function onClick,
    Color? customDarkColor,
    Color? customLightColor,
    bool loading = false,
  }) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: () {
        if (!loading) {
          onClick();
        }
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: ref.watch(isTabletProvider) ? 2.w : 3.5.w,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 3.5.w,
        ),
        decoration: BoxDecoration(
          color: isDarkMode
              ? loading
                  ? (AppColors.darkGreyColor)
                  : (customDarkColor ?? AppColors.darkGreenColor)
              : loading
                  ? (AppColors.darkGreyColor)
                  : (customLightColor ?? AppColors.lightGreenColor),
          borderRadius: BorderRadius.circular(2.5.w),
        ),
        child: Center(
          child: loading
              ? Text(
                  "Please wait..",
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.lightText
                        : loading
                            ? AppColors.lightGreyColor
                            : AppColors.darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  buttonText,
                  style: TextStyle(
                    color:
                        isDarkMode ? AppColors.lightText : AppColors.darkText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
