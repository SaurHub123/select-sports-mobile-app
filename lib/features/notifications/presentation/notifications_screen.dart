import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/common_appbar.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/core/models/notification_model.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Check if the current theme mode is dark
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final notificationsAsync = ref.watch(notificationsControllerProvider);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              VisibilityWidgets.statusBarVisibleWidget(context: context),
              CommonAppbar.appbarWithoutLeading(
                context,
                isDarkMode,
                "Notifications",
              ),
              notificationsAsync.when(
                data: (notifications) => notifications.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 10.w),
                        child: Text(
                          "No notifications found.",
                          style: AppTextStyles.body.copyWith(
                            color: isDarkMode
                                ? AppColors.lightText
                                : AppColors.darkText,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (final notification in notifications)
                            Column(
                              children: [
                                _buildNotificationTile(
                                  isDarkMode,
                                  notification.title,
                                  notification.message,
                                ),
                                SizedBox(height: 2.5.w),
                              ],
                            ),
                        ],
                      ),
                loading: () => Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: const CircularProgressIndicator(),
                ),
                error: (e, st) => Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: Text(
                    "Failed to load notifications.",
                    style: AppTextStyles.body.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    bool isDarkMode,
    String title,
    String description,
  ) {
    return Container(
      height: 100,
      width: 100.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5.w),
        color: isDarkMode
            ? AppColors.darkGreyColor
            : AppColors.lightestGreyColorV2,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreyColor.withValues(alpha: 0.5),
            blurRadius: 2.6,
            spreadRadius: 0,
            offset: Offset(
              1.95,
              1.95,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.w),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5.w),
            ),
            child: SvgPicture.asset(
              Paths.notificationIcon,
              color: isDarkMode ? AppColors.lightText : AppColors.darkText,
            ),
          ),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color:
                        isDarkMode ? AppColors.lightText : AppColors.darkText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.5.w),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: isDarkMode
                        ? AppColors.lightGreyColor
                        : AppColors.darkText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
