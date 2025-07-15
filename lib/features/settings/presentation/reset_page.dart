import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:select_sports/core/constants/paths.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/widgets/custom_buttons.dart';
import 'package:select_sports/core/widgets/custom_snackbar.dart';
import 'package:select_sports/core/widgets/custom_textfields.dart';
import 'package:select_sports/features/auth/presentation/auth_controller.dart';
import 'package:select_sports/features/auth/utils/validators.dart';

import '../../../providers/theme_provider.dart';

class ResetScreen extends ConsumerStatefulWidget {
  const ResetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetScreenState();
}

class _ResetScreenState extends ConsumerState<ResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = ref.read(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35.h,
                width: 100.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.darkestBackground,
                      AppColors.darkMediumBackground,
                      AppColors.darkLightBackground,
                    ],
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Positioned(
                      top: 0.h,
                      left: 20.w,
                      child: SizedBox(
                        height: 35.h,
                        width: 100.w,
                        child: Image(
                          image: AssetImage(
                            Paths.loginFootballImage,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 35.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reset",
                            style: AppTextStyles.largeHeading.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                          Text(
                            "Password",
                            style: AppTextStyles.largeHeading.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                          SizedBox(height: 2.5.w),
                          Text(
                            "Enter a new password to reset it.",
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow Back button
                    Positioned(
                      top: 7.5.h,
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
                            color: AppColors.lightGreenColor,
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
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 2.5.h, vertical: 2.5.h),
                child: Column(
                  children: [
                    CustomTextFields.outlinedWithIcon(
                      controller: authController.currentPasswordController,
                      hintText: "Enter current password",
                      labelText: "Current Password",
                      validator: Validators.validatePassword,
                      ref: ref,
                      obscureText: !authState.passwordVisible,
                      isPrefix: false,
                      icon: Icon(
                        authState.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      onIconPressed: () {
                        authController.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: 5.w),
                    CustomTextFields.outlinedWithIcon(
                      controller: authController.newPasswordController,
                      hintText: "Enter new password",
                      labelText: "New Password",
                      validator: Validators.validatePassword,
                      ref: ref,
                      obscureText: !authState.newPasswordVisible,
                      isPrefix: false,
                      icon: Icon(
                        authState.newPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      onIconPressed: () {
                        authController.toggleNewPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 2.5.h),
                    CustomTextFields.outlinedWithIcon(
                      controller: authController.confirmPasswordController,
                      hintText: "Confirm new password",
                      labelText: "Confirm Password",
                      validator: (value) => Validators.validateConfirmPassword(
                          value, authController.newPasswordController.text),
                      ref: ref,
                      obscureText: !authState.confirmPasswordVisible,
                      isPrefix: false,
                      icon: Icon(
                        authState.confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDarkMode
                            ? AppColors.lightText
                            : AppColors.darkText,
                      ),
                      onIconPressed: () {
                        authController.toggleConfirmPasswordVisibility();
                      },
                    ),
                    SizedBox(height: 5.w),
                    CustomButtons.fullWidthFilledButton(
                      ref: ref,
                      buttonText: "Reset Password",
                      onClick: () {
                        _submitForm();
                      },
                      customDarkColor: AppColors.lightGreenColor,
                      customLightColor: AppColors.lightGreenColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    final result = await ref.read(authControllerProvider.notifier).updatePassword();

    if (result['success']) {
      CustomSnackBar.showSuccess(result["message"]);
      Navigator.pop(context);
    } else {
      CustomSnackBar.showError(result["message"]);
    }
  }
}
