import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:select_sports/core/models/notification_model.dart';
import 'package:select_sports/core/network/api_client.dart';
import 'package:select_sports/core/constants/api_endpoints.dart';

class NotificationsRepository {
  final ApiClient apiClient;

  NotificationsRepository(this.apiClient);

  Future<List<UserNotification>> fetchNotifications() async {
    try {
      final response = await apiClient.authorizedGet(ApiEndpoints.userNotification);
      if (response.statusCode == 200) {
        final notifications = response.data['notifications'] as List<dynamic>;
        return notifications.map((n) => UserNotification.fromJson(n)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (kDebugMode) {
        print('NotificationsRepository Error:');
        print(e.response?.data["error"]);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(
    ApiClient(
      baseUrl: ApiEndpoints.baseUrl,
    ),
  ),
); 