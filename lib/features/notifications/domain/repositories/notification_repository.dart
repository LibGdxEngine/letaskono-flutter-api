import 'package:letaskono_flutter/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> fetchNotifications({int page});

  Future<int> fetchUnreadNotificationsCount();

  Future<void> readNotification(String id);
}
