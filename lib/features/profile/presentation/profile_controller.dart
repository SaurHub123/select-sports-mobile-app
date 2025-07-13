import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:select_sports/core/constants/theme_constants.dart';
import 'package:select_sports/core/models/user_model.dart';

import '../data/profile_repository.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository profileRepository;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController nearbyController = TextEditingController();

  ProfileController(this.profileRepository)
      : super(
          ProfileState(
            preferredPosition: null,
            experienceLevel: null,
            preferredFoot: null,
            totalMatches: 0,
            winnings: 0,
            draws: 0,
            loses: 0,
            isLoading: true,
            isProfileLoading: true,
            preferredPositionOptions: [],
            experienceLevelOptions: [],
            preferredFootOptions: [],
            gender: CommonAppOptions.genders[0],
            state: CommonAppOptions.states[0],
          ),
        ) {
    fetchSportsProfile();
    fetchProfileOptions();
  }

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

  void changesStateSelection(String selectedState) {
    state = state.copyWith(state: selectedState);
  }

  // Fetch profile data
  Future<void> fetchSportsProfile() async {
    state = state.copyWith(isLoading: true);

    final profile = await profileRepository.getSportsProfile();

    if (profile != null) {
      state = state.copyWith(
        preferredPosition: profile.preferredPosition,
        experienceLevel: profile.skillLevel,
        preferredFoot: profile.preferredFoot,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchUserProfile() async {
    state = state.copyWith(isLoading: false, isProfileLoading: false);

    final user =
        await profileRepository.getProfile(); // Fetch user profile data

    if (user != null) {
      state = state.copyWith(
        userDetail: user,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchProfileOptions() async {
    final options = await profileRepository.getProfileOptions();
    if (options != null) {
      state = state.copyWith(
        preferredPositionOptions: options.preferredPositionOptions,
        experienceLevelOptions: options.skillLevelOptions,
        preferredFootOptions: options.preferredFootOptions,
      );
    }
  }

  // Update the edit mode
  void toggleEditMode() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  // Update functions for dropdown selections
  void updatePreferredPosition(String newPosition) {
    state = state.copyWith(preferredPosition: newPosition);
  }

  void updateExperienceLevel(String newExperience) {
    state = state.copyWith(experienceLevel: newExperience);
  }

  void updatePreferredFoot(String newFoot) {
    state = state.copyWith(preferredFoot: newFoot);
  }

  Future<Map<String, dynamic>> updateProfile() async {
    try {
      state = state.copyWith(isUpdateProcessRunning: true);

      final response = await profileRepository.updateProfile(
        nameController.text.trim(),
        phoneController.text.trim(),
        dobController.text.trim(),
        state.gender,
        streetController.text.trim(),
        cityController.text.trim(),
        nearbyController.text.trim(),
        postalCodeController.text.trim(),
        state.state
      );

      return response;
    } finally {
      state = state.copyWith(isUpdateProcessRunning: false);
    }
  }

  // Available options
  static const List<String> preferredPositions = [
    'GOALKEEPER',
    'DEFENDER',
    'MIDFIELDER',
    'FORWARD'
  ];
  static const List<String> experienceLevels = [
    'BEGINNER',
    'INTERMEDIATE',
    'ADVANCED'
  ];
  static const List<String> preferredFoot = ['LEFT', 'RIGHT', 'BOTH'];
}

class ProfileState {
  final bool isEditing;
  final bool isLoading;
  final bool isProfileLoading;
  final bool isDobPickerOpen;
  final bool isUpdateProcessRunning;
  final String gender;
  final String state;
  final String? preferredPosition;
  final String? experienceLevel;
  final String? preferredFoot;
  final int totalMatches;
  final int winnings;
  final int draws;
  final int loses;
  final List<String> preferredPositionOptions;
  final List<String> experienceLevelOptions;
  final List<String> preferredFootOptions;
  final User? userDetail;

  ProfileState({
    this.isEditing = false,
    this.isLoading = false,
    this.isProfileLoading = false,
    this.isDobPickerOpen = false,
    this.isUpdateProcessRunning = false,
    required this.gender,
    required this.state,
    required this.preferredPosition,
    required this.experienceLevel,
    required this.preferredFoot,
    required this.totalMatches,
    required this.winnings,
    required this.draws,
    required this.loses,
    required this.preferredPositionOptions,
    required this.preferredFootOptions,
    required this.experienceLevelOptions,
    this.userDetail,
  });

  ProfileState copyWith({
    bool? isEditing,
    String? preferredPosition,
    String? experienceLevel,
    String? preferredFoot,
    bool? isLoading,
    bool? isProfileLoading,
    int? totalMatches,
    int? winnings,
    int? draws,
    int? loses,
    List<String>? preferredPositionOptions,
    List<String>? preferredFootOptions,
    List<String>? experienceLevelOptions,
    User? userDetail,
    bool? isUpdateProcessRunning,
    bool? isDobPickerOpen,
    String? gender,
    String? state,
  }) {
    return ProfileState(
      isEditing: isEditing ?? this.isEditing,
      preferredPosition: preferredPosition ?? this.preferredPosition,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      preferredFoot: preferredFoot ?? this.preferredFoot,
      isLoading: isLoading ?? this.isLoading,
      isProfileLoading: isProfileLoading ?? this.isProfileLoading,
      totalMatches: totalMatches ?? this.totalMatches,
      winnings: winnings ?? this.winnings,
      draws: draws ?? this.draws,
      loses: loses ?? this.loses,
      preferredPositionOptions:
          preferredPositionOptions ?? this.preferredPositionOptions,
      preferredFootOptions: preferredFootOptions ?? this.preferredFootOptions,
      experienceLevelOptions:
          experienceLevelOptions ?? this.experienceLevelOptions,
      userDetail: userDetail ?? this.userDetail,
      gender: gender ?? this.gender,
      isUpdateProcessRunning:
          isUpdateProcessRunning ?? this.isUpdateProcessRunning,
      isDobPickerOpen: isDobPickerOpen ?? this.isDobPickerOpen,
      state: state ?? this.state,
    );
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(profileRepository);
  // return ProfileController();
});
