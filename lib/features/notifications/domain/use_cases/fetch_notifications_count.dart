import 'package:letaskono_flutter/features/notifications/domain/repositories/notification_repository.dart';
import 'package:letaskono_flutter/features/notifications/domain/entities/notification_entity.dart';

class FetchUnreadNotificationsCount {
  final NotificationRepository repository;

  FetchUnreadNotificationsCount(this.repository);

  Future<int> call() async {
    return await repository.fetchUnreadNotificationsCount();
  }
}
