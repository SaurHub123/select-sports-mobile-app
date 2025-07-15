import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notifications_repository.dart';
import 'package:select_sports/core/models/notification_model.dart';

class NotificationsController extends StateNotifier<AsyncValue<List<UserNotification>>> {
  final NotificationsRepository repository;

  NotificationsController(this.repository) : super(const AsyncValue.loading()) {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await repository.fetchNotifications();
      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final notificationsControllerProvider = StateNotifierProvider<NotificationsController, AsyncValue<List<UserNotification>>>(
  (ref) {
    final repo = ref.watch(notificationsRepositoryProvider);
    return NotificationsController(repo);
  },
); 