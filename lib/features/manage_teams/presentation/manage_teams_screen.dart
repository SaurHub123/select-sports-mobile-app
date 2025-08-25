import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/common_appbar.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/providers/responsive_provider.dart';
import 'package:select_sports/providers/theme_provider.dart';

class ManageTeamsScreen extends ConsumerStatefulWidget {
  const ManageTeamsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageTeamsScreenState();
}

class _ManageTeamsScreenState extends ConsumerState<ManageTeamsScreen> {
  @override
  Widget build(BuildContext context) {
    // Check if the current theme mode is dark
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.transparent: Color(0xFFEBF0EA),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VisibilityWidgets.statusBarVisibleWidget(context: context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CommonAppbar.appbarWithoutLeading(
                context,
                isDarkMode,
                "Manage Teams",
              ),
            ),
            if(!ref.watch(isTabletProvider))
            SizedBox(height: 5.h),
            Lottie.asset(
              isDarkMode
                  ? Paths.lottieDarkCodingJson
                  : Paths.lottieCodingJson,
              animate: true,
            ),
            if(!ref.watch(isTabletProvider))
            SizedBox(height: 2.5.w),
            Center(
              child: Text(
                "We are still working on it!",
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: isDarkMode ? Color(0xFF26D6B6) : AppColors.darkText,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                ),
                SizedBox(width: 2.5.w),
                Text(
                  "Stay Tuned!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color:
                        isDarkMode ? AppColors.lightText : AppColors.darkText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
