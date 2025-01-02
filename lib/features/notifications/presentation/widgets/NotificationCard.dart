import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hDate = HijriCalendar.fromDate(notification.createdAt);
    return GestureDetector(
      onTap: () {
        switch (notification.messageAction) {
          case 'رسالة جديدة':
            Navigator.pop(context, "chat");
            break;
          case 'تغيير في حالة المحادثة':
            Navigator.pop(context, "chat");
            break;
          case 'طلب جديد':
            Navigator.pop(context, "requests");
            break;
          case 'طلب مقبول':
            Navigator.pop(context, "chat");
            break;
          case 'طلب مرفوض':
            Navigator.pop(context, "requests");
            break;
          case 'دخول محادثة':
            Navigator.pop(context, "chat");
            break;
          case 'إنهاء محادثة':
            Navigator.pop(context, "chat");
            break;
          case 'خطبة':
            Navigator.pop(context, "chat");
            break;
          case 'غير ذلك':
            Navigator.pop(context, "chat");
            break;
          default:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'بتاريخ: ${hDate}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            )
          ],
        ),
      ),
    );
  }
}
