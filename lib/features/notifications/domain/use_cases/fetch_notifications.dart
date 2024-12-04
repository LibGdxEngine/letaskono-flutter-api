import 'package:letaskono_flutter/features/notifications/domain/repositories/notification_repository.dart';
import 'package:letaskono_flutter/features/notifications/domain/entities/notification_entity.dart';

class FetchNotifications {
  final NotificationRepository repository;

  FetchNotifications(this.repository);

  Future<List<NotificationEntity>> call({required int page}) async {
    return await repository.fetchNotifications(page: page);
  }
}
