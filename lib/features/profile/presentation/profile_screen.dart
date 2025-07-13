import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/custom_buttons.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/features/profile/presentation/profile_controller.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:select_sports/providers/theme_provider.dart';
import 'package:select_sports/core/widgets/common_dropdowns.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).fetchSportsProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the current theme mode is dark
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final profileState = ref.watch(profileControllerProvider);
    final profileNotifier = ref.read(profileControllerProvider.notifier);

    if (profileState.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          children: [
            VisibilityWidgets.statusBarVisibleWidget(context: context),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.darkGreyColor
                            : AppColors.lightGreyColor,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 37.5.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.darkGreyColor
                                : AppColors.lightGreyColor,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 31.h,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.darkText
                                  : AppColors.lightGreyColor,
                              shape: BoxShape.circle,
                            ),
                            child: SfRadialGauge(
                              axes: [
                                RadialAxis(
                                  showLabels: false,
                                  showTicks: false,
                                  startAngle: 270,
                                  endAngle: 630,
                                  radiusFactor: 0.7,
                                  canScaleToFit: true,
                                  axisLineStyle: AxisLineStyle(
                                    thickness: 0.1,
                                    color: AppColors.darkGreyColor,
                                    thicknessUnit: GaugeSizeUnit.factor,
                                    cornerStyle: CornerStyle.startCurve,
                                  ),
                                  pointers: <GaugePointer>[
                                    RangePointer(
                                      value: 75,
                                      width: 0.1,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: AppColors.lightText,
                                      cornerStyle: CornerStyle.bothCurve,
                                    ),
                                    RangePointer(
                                      value: 52,
                                      width: 0.1,
                                      color: AppColors.darkGreyColor,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      cornerStyle: CornerStyle.bothCurve,
                                    ),
                                    RangePointer(
                                      value: 50,
                                      width: 0.1,
                                      color: AppColors.mediumGreenColor,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      cornerStyle: CornerStyle.bothCurve,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16.5.h,
                    left: 10.5.h,
                    child: Hero(
                      tag: "profile-icon",
                      child: Container(
                        height: 17.h,
                        width: 25.h,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              Paths.profileImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: SizedBox(
                      height: 100.h,
                      width: 100.w,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 50.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                            ),
                            SizedBox(height: 5.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 5.w,
                              ),
                              child: Column(
                                children: [
                                  !profileState.isEditing
                                      ? _buildActions(
                                          Paths.profileTouchesImage,
                                          "Position",
                                          profileState.preferredPosition,
                                          isTotal: false,
                                        )
                                      : Consumer(
                                          builder: (context, ref, child) {
                                            return _buildActionsWithDropdown(
                                              Paths.profileTouchesImage,
                                              "Position",
                                              profileState.preferredPosition,
                                              profileState
                                                  .preferredPositionOptions,
                                              (value) => profileNotifier
                                                  .updatePreferredPosition(
                                                      value!),
                                            );
                                          },
                                        ),
                                  SizedBox(height: 2.5.w),
                                  !profileState.isEditing
                                      ? _buildActions(
                                          Paths.profileTouchesImage,
                                          "Experience",
                                          profileState.experienceLevel,
                                          isTotal: false,
                                        )
                                      : Consumer(
                                          builder: (context, ref, child) {
                                            return _buildActionsWithDropdown(
                                              Paths.profileTouchesImage,
                                              "Experience",
                                              profileState.experienceLevel,
                                              profileState
                                                  .experienceLevelOptions,
                                              (value) => profileNotifier
                                                  .updateExperienceLevel(
                                                      value!),
                                            );
                                          },
                                        ),
                                  SizedBox(height: 2.5.w),
                                  !profileState.isEditing
                                      ? _buildActions(
                                          Paths.profileTouchesImage,
                                          "Preferred Foot",
                                          profileState.preferredFoot,
                                          isTotal: false,
                                        )
                                      : Consumer(
                                          builder: (context, ref, child) {
                                            return _buildActionsWithDropdown(
                                              Paths.profileTouchesImage,
                                              "Preferred Foot",
                                              profileState.preferredFoot,
                                              profileState.preferredFootOptions,
                                              (value) => profileNotifier
                                                  .updatePreferredFoot(value!),
                                            );
                                          },
                                        ),
                                  SizedBox(height: 2.5.w),
                                  _buildActions(
                                    Paths.profileTouchesImage,
                                    "Total Matches",
                                    profileState.totalMatches,
                                  ),
                                  SizedBox(height: 2.5.w),
                                  _buildActions(
                                    Paths.profileShotsImage,
                                    "Winnings",
                                    profileState.winnings,
                                  ),
                                  SizedBox(height: 2.5.w),
                                  _buildActions(
                                    Paths.profilePassesImage,
                                    "Draws",
                                    profileState.draws,
                                  ),
                                  SizedBox(height: 2.5.w),
                                  _buildActions(
                                    Paths.profilePassesImage,
                                    "Loses",
                                    profileState.loses,
                                  ),
                                  SizedBox(height: 2.5.w),
                                  Container(
                                    width: 100.w,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1.5.w),
                                    child: CustomButtons.fullWidthFilledButton(
                                      buttonText: "Update Profile",
                                      ref: ref,
                                      onClick: () {
                                        ref
                                            .read(profileControllerProvider
                                                .notifier)
                                            .toggleEditMode();
                                      },
                                    ),
                                  ),
                                  VisibilityWidgets.bottomNavBarVisibleWidget(
                                      height: 140),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Back Arrow Button
                  Positioned(
                    top: 2.5.w,
                    left: 5.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.5.w,
                          vertical: 2.5.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mediumGreenColor,
                          borderRadius: BorderRadius.circular(2.5.w),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActions(String icon, String title, var totalValue,
      {bool isTotal = true}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.5.w,
        horizontal: 2.5.w,
      ),
      width: 100.w,
      decoration: BoxDecoration(
        color: AppColors.darkGreyColor,
        borderRadius: BorderRadius.circular(2.5.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.subheading.copyWith(
                  color: AppColors.lightText,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Row(
            children: [
              isTotal
                  ? Text(
                      "Total: ",
                      style: AppTextStyles.body
                          .copyWith(color: AppColors.lightGreyColor),
                    )
                  : SizedBox(),
              SizedBox(width: 1.w),
              isTotal
                  ? Text(
                      totalValue.toString(),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.lightText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 2.5.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsWithDropdown(
    String icon,
    String title,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.5.w,
        horizontal: 2.5.w,
      ),
      width: 100.w,
      decoration: BoxDecoration(
        color: AppColors.darkGreyColor,
        borderRadius: BorderRadius.circular(2.5.w),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5.w),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    color: AppColors.lightText,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.subheading.copyWith(
                  color: AppColors.lightText,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          CommonDropdown(
            items: options,
            selectedValue: selectedValue,
            onChanged: onChanged,
          ),
          SizedBox(width: 2.5.w),
        ],
      ),
    );
  }
}
