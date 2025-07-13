class MembershipValidators {
  static String? validateOccupation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Occupation is required";
    }
    return null;
  }

  static String? validatePlayFootball(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select whether you play football";
    }
    return null;
  }

  static String? validateCar(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select whether you have a car";
    }
    return null;
  }

  static String? validateBike(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select whether you have a bike";
    }
    return null;
  }

  static String? validateUsedThisApp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select whether you have used this app before";
    }
    return null;
  }

  static String? validateExperienceInOrgCS(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select whether you have experience in organized community sports";
    }
    return null;
  }

  static String? validateCommitHours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select your commitment hours";
    }
    return null;
  }

  static String? validatePreferredSchedule(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please select your preferred schedule";
    }
    return null;
  }

  static String? validateKeyHighlights(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Key highlights are required";
    }
    if (value.trim().length < 10) {
      return "Key highlights must be at least 10 characters long";
    }
    if (value.trim().length > 500) {
      return "Key highlights must not exceed 500 characters";
    }
    return null;
  }

  static String? validateCurrentLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Current location is required";
    }
    return null;
  }
} 