class ApiEndpoints {
  static const String baseUrl = "http://localhost:3005/api";
  // static const String baseUrl = "http://13.201.71.232/api";

  // Auth Endpoints
  static const String login = "/auth/login";
  static const String signup = "/auth/register";
  static const String me = "/auth/me";
  static const String forgot = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String verifyOtp = "/auth/verify-account";
  static const String userProfile = "/user/sports-profile";
  static const String availableSlots = "/slots";
  static const String bookings = "/bookings";
  static const String venues = "/venues";
  static const String sportsProfileOptions = "/user/sports-profile-options";
  static const String initiatePayment = "/razorpay-transactions/initiate";
  static const String verifyPayment = "/razorpay-transactions/verify";
}
