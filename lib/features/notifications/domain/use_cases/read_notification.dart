import 'package:letaskono_flutter/features/notifications/domain/repositories/notification_repository.dart';
import 'package:letaskono_flutter/features/notifications/domain/entities/notification_entity.dart';

class ReadNotification {
  final NotificationRepository repository;

  ReadNotification(this.repository);

  Future<void> call(String id) async {
    return await repository.readNotification(id);
  }
}
