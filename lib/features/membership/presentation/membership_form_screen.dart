import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/membership_constants.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/common_appbar.dart';
import 'package:select_sports/core/widgets/common_dropdowns.dart';
import 'package:select_sports/core/widgets/custom_buttons.dart';
import 'package:select_sports/core/widgets/custom_snackbar.dart';
import 'package:select_sports/core/widgets/custom_textfields.dart';
import 'package:select_sports/core/widgets/visibility_widgets.dart';
import 'package:select_sports/features/membership/presentation/membership_controller.dart';
import 'package:select_sports/features/membership/presentation/validators.dart';
import 'package:select_sports/providers/theme_provider.dart';

class MembershipFormScreen extends ConsumerStatefulWidget {
  const MembershipFormScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MembershipFormScreenState();
}

class _MembershipFormScreenState extends ConsumerState<MembershipFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final membershipController = ref.read(membershipControllerProvider.notifier);
    final membershipState = ref.watch(membershipControllerProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.transparent : Color(0xFFEBF0EA),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VisibilityWidgets.statusBarVisibleWidget(context: context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Host Application",
                        style: AppTextStyles.heading.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Please fill out the form below to apply for host membership. Your application will be reviewed by our admin team.",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightGreyColor : AppColors.mediumGreyColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      
                      // Occupation Dropdown
                      Text(
                        "Occupation",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.occupationOptions,
                        selectedValue: membershipState.occupation,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateOccupation(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Play Football Dropdown
                      Text(
                        "Do you play football?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.yesNoOptions,
                        selectedValue: membershipState.playFootball,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updatePlayFootball(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Car Dropdown
                      Text(
                        "Do you have a car?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.yesNoOptions,
                        selectedValue: membershipState.car,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateCar(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Bike Dropdown
                      Text(
                        "Do you have a bike?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.yesNoOptions,
                        selectedValue: membershipState.bike,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateBike(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Used This App Dropdown
                      Text(
                        "Have you used this app before?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.yesNoOptions,
                        selectedValue: membershipState.usedThisApp,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateUsedThisApp(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Experience in Organized Community Sports Dropdown
                      Text(
                        "Do you have experience in organized community sports?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.yesNoOptions,
                        selectedValue: membershipState.experienceInOrgCS,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateExperienceInOrgCS(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Commit Hours Dropdown
                      Text(
                        "How many hours can you commit?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.commitHoursOptions,
                        selectedValue: membershipState.commitHours,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateCommitHours(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Preferred Schedule Dropdown
                      Text(
                        "What is your preferred schedule?",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.scheduleOptions,
                        selectedValue: membershipState.preferredSchedule,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updatePreferredSchedule(value);
                          }
                        },
                      ),
                      SizedBox(height: 3.h),

                      // Key Highlights TextField
                      CustomTextFields.outlined(
                        controller: membershipController.keyHighlightsController,
                        hintText: "Tell us about your key highlights and achievements...",
                        labelText: "Key Highlights",
                        validator: MembershipValidators.validateKeyHighlights,
                        ref: ref,
                        maxLines: 4,
                        maxLength: 500,
                      ),
                      SizedBox(height: 3.h),

                      // Current Location Dropdown
                      Text(
                        "Current Location",
                        style: AppTextStyles.body.copyWith(
                          color: isDarkMode ? AppColors.lightText : AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      CommonDropdown(
                        items: MembershipConstants.availableStates,
                        selectedValue: membershipState.currentLocation,
                        onChanged: (value) {
                          if (value != null) {
                            membershipController.updateCurrentLocation(value);
                          }
                        },
                      ),
                      SizedBox(height: 5.h),

                      // Submit Button
                      CustomButtons.fullWidthFilledButton(
                        ref: ref,
                        buttonText: "Submit Application",
                        loading: membershipState.isSubmitting,
                        onClick: () {
                          _submitForm();
                        },
                        customDarkColor: AppColors.lightGreenColor,
                        customLightColor: AppColors.lightGreenColor,
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _submitApplication();
    }
  }

  Future<void> _submitApplication() async {
    final membershipController = ref.read(membershipControllerProvider.notifier);
    final result = await membershipController.submitHostApplication();
    print(result);

    if (mounted) {
      if (result['success']) {
        CustomSnackBar.showSuccess("Your application has been submitted successfully! Admin will review your application and get back to you soon.");
      } else {
        CustomSnackBar.showError(result['message']);
      }
    }
  }
} 