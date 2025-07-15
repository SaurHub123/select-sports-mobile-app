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
import 'package:select_sports/providers/theme_provider.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                              Paths.loginTopImage,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 35.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Verify",
                              style: AppTextStyles.largeHeading.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                            Text(
                              "OTP",
                              style: AppTextStyles.largeHeading.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                            SizedBox(height: 2.5.w),
                            Text(
                              "Enter the OTP sent to your email",
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.5.h,
                    vertical: 2.5.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.w),
                      CustomTextFields.outlined(
                        keyboardType: TextInputType.number,
                        controller: authController.otpController,
                        hintText: "Enter OTP",
                        labelText: "OTP",
                        validator: Validators.validateOTP,
                        ref: ref,
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
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomButtons.fullWidthFilledButton(
                        ref: ref,
                        buttonText: "Verify",
                        onClick: () {
                          _submitForm();
                        },
                      ),
                      SizedBox(height: 5.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the OTP? ",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              color: isDarkMode
                                  ? AppColors.lightText
                                  : AppColors.darkText,
                            ),
                          ),
                          InkWell(
                            overlayColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            onTap: () {
                              // _resendOTP();
                            },
                            child: Text(
                              " Resend OTP",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.body.copyWith(
                                color: isDarkMode
                                    ? AppColors.lightGreenColor
                                    : AppColors.darkGreenColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _verifyOTP();
    }
  }

  Future<void> _verifyOTP() async {
    // Check if the widget is still mounted before triggering UI updates
    final result = await ref.read(authControllerProvider.notifier).reset();

    if (mounted) {
      if (result['success']) {
        CustomSnackBar.showSuccess(result["message"]);
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        CustomSnackBar.showError(result["message"]);
      }
    }
  }
}
