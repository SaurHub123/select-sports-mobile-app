import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/common_appbar.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/providers/theme_provider.dart';

class PendingApplicationScreen extends ConsumerWidget {
  const PendingApplicationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.transparent : Color(0xFFEBF0EA),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VisibilityWidgets.statusBarVisibleWidget(context: context),
            SizedBox(height: 10.h),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie.asset(
                    //   Paths.codingJson,
                    //   height: 30.h,
                    //   width: 30.w,
                    // ),
                    SizedBox(height: 5.h),
                    Text(
                      "Application Pending",
                      style: AppTextStyles.heading.copyWith(
                        color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "Your host application is currently under review. Our admin team will get back to you soon with a decision.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightGreyColor : AppColors.mediumGreyColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.darkGreyColor : AppColors.lightestGreyColor,
                        borderRadius: BorderRadius.circular(2.5.w),
                        border: Border.all(
                          color: isDarkMode ? AppColors.lightGreenColor : AppColors.lightGreenColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppColors.lightGreenColor,
                            size: 24.sp,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "Status: PENDING",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.lightGreenColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 