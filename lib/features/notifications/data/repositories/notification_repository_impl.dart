import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notifications_remote_data_source.dart';
import '../models/notification.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> fetchNotifications({int page = 1}) async {
    final List<Notification> notifications =
        await remoteDataSource.fetchNotifications(page: page);
    return notifications
        .map((notification) => _mapNotificationToEntity(notification))
        .toList();
  }

  NotificationEntity _mapNotificationToEntity(Notification notification) {
    return NotificationEntity(
      id: notification.id,
      createdAt: notification.createdAt,
      isRead: notification.isRead,
      message: notification.message,
      title: notification.title,
    );
  }
}
