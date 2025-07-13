import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/constants/membership_constants.dart';
import 'package:select_sports/features/membership/data/membership_repository.dart';

class MembershipState {
  final bool isLoading;
  final bool isSubmitting;
  final bool isHost;
  final String? hostStatus;
  final String? occupation;
  final String? playFootball;
  final String? car;
  final String? bike;
  final String? usedThisApp;
  final String? experienceInOrgCS;
  final String? commitHours;
  final String? preferredSchedule;
  final String? currentLocation;
  final List<String> selectedSchedules;

  MembershipState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.isHost = false,
    this.hostStatus,
    required this.occupation,
    required this.playFootball,
    required this.car,
    required this.bike,
    required this.usedThisApp,
    required this.experienceInOrgCS,
    required this.commitHours,
    required this.preferredSchedule,
    required this.currentLocation,
    required this.selectedSchedules,
  });

  MembershipState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isHost,
    String? hostStatus,
    String? occupation,
    String? playFootball,
    String? car,
    String? bike,
    String? usedThisApp,
    String? experienceInOrgCS,
    String? commitHours,
    String? preferredSchedule,
    String? currentLocation,
    List<String>? selectedSchedules,
  }) {
    return MembershipState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isHost: isHost ?? this.isHost,
      hostStatus: hostStatus ?? this.hostStatus,
      occupation: occupation ?? this.occupation,
      playFootball: playFootball ?? this.playFootball,
      car: car ?? this.car,
      bike: bike ?? this.bike,
      usedThisApp: usedThisApp ?? this.usedThisApp,
      experienceInOrgCS: experienceInOrgCS ?? this.experienceInOrgCS,
      commitHours: commitHours ?? this.commitHours,
      preferredSchedule: preferredSchedule ?? this.preferredSchedule,
      currentLocation: currentLocation ?? this.currentLocation,
      selectedSchedules: selectedSchedules ?? this.selectedSchedules,
    );
  }
}

class MembershipController extends StateNotifier<MembershipState> {
  final MembershipRepository membershipRepository;

  // Text controllers for form
  final TextEditingController keyHighlightsController = TextEditingController();

  MembershipController(this.membershipRepository)
      : super(
          MembershipState(
            occupation: null,
            playFootball: null,
            car: null,
            bike: null,
            usedThisApp: null,
            experienceInOrgCS: null,
            commitHours: null,
            preferredSchedule: null,
            currentLocation: null,
            selectedSchedules: [],
          ),
        ) {
    checkHostStatus();
  }

  Future<void> checkHostStatus() async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await membershipRepository.getMe();
      
      if (result['success']) {
        final data = result['data'];
        
        // Check if hostProfile exists and has a valid status
        final hostProfile = data['hostProfile'];
        bool isHost = false;
        String? hostStatus;
        
        if (hostProfile != null) {
          hostStatus = hostProfile['status'];
          // Consider as host if status is PENDING, APPROVED, or any valid status
          isHost = hostStatus != null && hostStatus.isNotEmpty;
        } else {
          // Fallback to isHost field if hostProfile doesn't exist
          isHost = data['isHost'] ?? false;
        }
        
        state = state.copyWith(isHost: isHost, hostStatus: hostStatus, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateOccupation(String value) {
    state = state.copyWith(occupation: value);
  }

  void updatePlayFootball(String value) {
    state = state.copyWith(playFootball: value);
  }

  void updateCar(String value) {
    state = state.copyWith(car: value);
  }

  void updateBike(String value) {
    state = state.copyWith(bike: value);
  }

  void updateUsedThisApp(String value) {
    state = state.copyWith(usedThisApp: value);
  }

  void updateExperienceInOrgCS(String value) {
    state = state.copyWith(experienceInOrgCS: value);
  }

  void updateCommitHours(String value) {
    state = state.copyWith(commitHours: value);
  }

  void updatePreferredSchedule(String value) {
    state = state.copyWith(preferredSchedule: value);
  }

  void updateCurrentLocation(String value) {
    state = state.copyWith(currentLocation: value);
  }

  void updateSelectedSchedules(List<String> schedules) {
    state = state.copyWith(selectedSchedules: schedules);
  }

  Future<Map<String, dynamic>> submitHostApplication() async {
    try {
      state = state.copyWith(isSubmitting: true);

      final data = {
        'occupation': state.occupation,
        'playFootball': state.playFootball,
        'car': state.car,
        'bike': state.bike,
        'usedThisApp': state.usedThisApp,
        'experienceInOrgCS': state.experienceInOrgCS,
        'commitHours': state.commitHours,
        'preferredSchedule': [state.preferredSchedule],
        'keyHighlights': keyHighlightsController.text.trim(),
        'currentLocation': state.currentLocation,
      };

      final response = await membershipRepository.submitHostApplication(data);
      return response;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  void resetForm() {
    keyHighlightsController.clear();
    state = state.copyWith(
      occupation: MembershipConstants.occupationOptions[0],
      playFootball: MembershipConstants.yesNoOptions[0],
      car: MembershipConstants.yesNoOptions[0],
      bike: MembershipConstants.yesNoOptions[0],
      usedThisApp: MembershipConstants.yesNoOptions[0],
      experienceInOrgCS: MembershipConstants.yesNoOptions[0],
      commitHours: MembershipConstants.commitHoursOptions[0],
      preferredSchedule: MembershipConstants.scheduleOptions[0],
      currentLocation: MembershipConstants.availableStates[0],
      selectedSchedules: [],
    );
  }

  @override
  void dispose() {
    keyHighlightsController.dispose();
    super.dispose();
  }
}

final membershipControllerProvider = StateNotifierProvider<MembershipController, MembershipState>(
  (ref) => MembershipController(ref.read(membershipRepositoryProvider)),
); 