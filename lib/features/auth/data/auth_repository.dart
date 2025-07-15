import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/network/api_client.dart';
import 'package:select_sports/core/constants/api_endpoints.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<Map<String, dynamic>> forgot(String email) async {
    try {
      final response = await apiClient.post(ApiEndpoints.forgot, {
        'email': email,
      });

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': message,
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"]};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await apiClient.post(ApiEndpoints.verifyOtp, {
        'email': email,
        'otp': otp,
      });

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': message,
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"]};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> reset(
      String email, String otp, String newPassword) async {
    try {
      final response = await apiClient.post(ApiEndpoints.resetPassword, {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      });

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': response.data["message"],
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"]};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final response =
          await apiClient.authorizedPatch(ApiEndpoints.updatePassword, {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': response.data["message"],
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"]};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await apiClient.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': "Login Successful",
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {'success': false, 'message': "Login Unsuccessful"};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String phone,
    String dob,
    String gender,
  ) async {
    try {
      final response = await apiClient.post(ApiEndpoints.signup, {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'dob': dob,
        'gender': gender,
      });

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': response.data['message'],
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data["error"]);
      }
      // Check if the response contains a valid error message
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data.containsKey("message")) {
        return {'success': false, 'message': data["message"]};
      }

      return {'success': false, 'message': "An unknown error occurred."};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
    ),
  ),
);
