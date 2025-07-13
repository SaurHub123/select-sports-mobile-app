import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/network/api_client.dart';
import 'package:select_sports/core/constants/api_endpoints.dart';

class MembershipRepository {
  final ApiClient apiClient;

  MembershipRepository(this.apiClient);

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await apiClient.authorizedGet(ApiEndpoints.me);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': "Data fetched successfully",
        };
      }

      return {'success': false, 'message': "Failed to fetch data"};
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Membership Repository Error [Get Me]:");
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"] ?? "Network error"};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> submitHostApplication(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.authorizedPost(ApiEndpoints.host, data);

      final message = response.data['message'] ?? "Unexpected response";

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': response.data['data'],
          'message': message,
        };
      }

      return {'success': false, 'message': message};
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Membership Repository Error [Submit Host Application]:");
        print(e.response?.data["error"]);
      }
      return {'success': false, 'message': e.response?.data["message"] ?? "Network error"};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

final membershipRepositoryProvider = Provider<MembershipRepository>(
  (ref) => MembershipRepository(
    ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
    ),
  ),
); 