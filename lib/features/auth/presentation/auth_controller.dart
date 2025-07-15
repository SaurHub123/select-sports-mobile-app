import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:select_sports/core/constants/shared_preferences_keys.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/network/shared_preferences_helper.dart';
import 'package:select_sports/core/widgets/custom_snackbar.dart';
import 'package:select_sports/features/auth/data/auth_repository.dart';

class AuthState {
  final bool passwordVisible;
  final bool newPasswordVisible;
  final bool confirmPasswordVisible;
  final String gender;
  final bool isLoginProcessRunning;
  final bool isSignUpProcessRunning;
  final bool isDobPickerOpen;
  final bool isForgotProcessRunning;
  final bool isVerifyProcessRunning;

  AuthState({
    required this.passwordVisible,
    required this.newPasswordVisible,
    required this.confirmPasswordVisible,
    required this.gender,
    this.isLoginProcessRunning = false,
    this.isSignUpProcessRunning = false,
    this.isDobPickerOpen = false,
    this.isForgotProcessRunning = false,
    this.isVerifyProcessRunning = false,
  });

  // CopyWith method for immutability
  AuthState copyWith({
    bool? passwordVisible,
    bool? newPasswordVisible,
    bool? confirmPasswordVisible,
    bool? currentPasswordVisible,
    bool? isLoginProcessRunning,
    bool? isSignUpProcessRunning,
    bool? isDobPickerOpen,
    bool? isForgotProcessRunning,
    bool? isVerifyProcessRunning,
    String? gender,
  }) {
    return AuthState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      newPasswordVisible: newPasswordVisible ?? this.newPasswordVisible,
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
      isLoginProcessRunning:
          isLoginProcessRunning ?? this.isLoginProcessRunning,
      isSignUpProcessRunning:
          isSignUpProcessRunning ?? this.isSignUpProcessRunning,
      isDobPickerOpen: isDobPickerOpen ?? this.isDobPickerOpen,
      isForgotProcessRunning: isForgotProcessRunning ?? this.isForgotProcessRunning,
      isVerifyProcessRunning: isVerifyProcessRunning ?? this.isVerifyProcessRunning,
      gender: gender ?? this.gender,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  // Text controllers for login and signup forms
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController newPhoneController = TextEditingController();

  AuthController(this.authRepository)
      : super(
          AuthState(
            passwordVisible: false,
            newPasswordVisible: false,
            confirmPasswordVisible: false,
            isLoginProcessRunning: false,
            isSignUpProcessRunning: false,
            isForgotProcessRunning: false,
            isVerifyProcessRunning: false,
            gender: CommonAppOptions.genders[0],
          ),
        );

  void openDobPicker() {
    state = state.copyWith(isDobPickerOpen: true);
  }

  void closeDobPicker() {
    state = state.copyWith(isDobPickerOpen: false);
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime earliestDate =
        now.subtract(const Duration(days: 65 * 365)); // 65 years ago
    DateTime latestDate =
        now.subtract(const Duration(days: 15 * 365)); // 15 years ago

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: latestDate,
      firstDate: earliestDate,
      lastDate: latestDate,
    );

    if (pickedDate != null) {
      dobController.text = DateFormat("dd-MM-yyyy").format(pickedDate);
      closeDobPicker();
    }
  }

  void changeGenderSelection(String gender) {
    state = state.copyWith(gender: gender);
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleNewPasswordVisibility() {
    state = state.copyWith(newPasswordVisible: !state.newPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state =
        state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible);
  }

  Future<Map<String, dynamic>> login() async {
    try {
      state = state.copyWith(isLoginProcessRunning: true);

      final response = await authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      return response;
    } finally {
      state = state.copyWith(isLoginProcessRunning: false);
    }
  }

  void resetLoginForm() {
    emailController.clear();
    passwordController.clear();
  }

  Future<Map<String, dynamic>> signup() async {
    try {
      state = state.copyWith(isSignUpProcessRunning: true);

      final response = await authRepository.signup(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        phoneController.text.trim(),
        dobController.text.trim(),
        state.gender,
      );

      return response;
    } finally {
      state = state.copyWith(isSignUpProcessRunning: false);
    }
  }

  void resetSignupForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    dobController.clear();
    state.copyWith(gender: CommonAppOptions.genders[0]);
  }

  Future<Map<String, dynamic>> forgot() async {
    try {
      state = state.copyWith(isForgotProcessRunning: true);
      final response = await authRepository.forgot(emailController.text.trim());
      return response;
    } finally {
      state = state.copyWith(isForgotProcessRunning: false);
    }
  }

  Future<Map<String, dynamic>> verify() {
    return authRepository.verifyOtp(
        emailController.text.trim(), otpController.text.trim());
  }

  Future<Map<String, dynamic>> reset() async {
    try {
      state = state.copyWith(isVerifyProcessRunning: true);
      final response = await authRepository.reset(emailController.text.trim(),
        otpController.text.trim(), newPasswordController.text.trim());
      return response;
    } finally {
      state = state.copyWith(isVerifyProcessRunning: false);
    }
  }

  Future<Map<String, dynamic>> updatePassword() {
    return authRepository.updatePassword(currentPasswordController.text.trim(), newPasswordController.text.trim());
  }

  Future<bool> logout() async {
    await SharedPreferencesHelper.clear();
    // After logging out User must not be redirected to Onboarding Page
    await SharedPreferencesHelper.set(
        SharedPreferencesKeys.alreadyVisited, true);
    CustomSnackBar.showSuccess("Successfully logged out.");
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.read(authRepositoryProvider)),
);
