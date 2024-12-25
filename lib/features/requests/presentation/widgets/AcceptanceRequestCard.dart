import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:letaskono_flutter/core/utils/CustomButton.dart';
import 'package:letaskono_flutter/features/requests/data/models/request_type.dart';
import 'package:letaskono_flutter/features/requests/domain/entities/AcceptanceRequestEntity.dart';

class AcceptanceRequestCard extends StatelessWidget {
  final AcceptanceRequestEntity request;
  final Function onAccept;
  final Function onReject;

  const AcceptanceRequestCard({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Map<String, String> requestStatusTranslations = {
      'SENT': 'مرسل',
      'ACCEPTED': 'مقبول',
      'REJECTED': 'مرفوض',
      'TIMED_OUT': 'انتهت المهلة',
    };
    final date = DateTime.parse(request.timestamp);
    final hDate = HijriCalendar.fromDate(date);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.requestType == RequestType.sent
                ? "لقد أرسلت طلب قبول لـ${request.sender}"
                : "لقد تلقيت طلب قبول من  ${request.sender}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("حالة الطلب: ${requestStatusTranslations[request.status]}"),
              const SizedBox(height: 8),
              Text("بتاريخ: ${hDate}"),
            ],
          ),
          const SizedBox(height: 8),
          if (request.status == "ACCEPTED")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAccept(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text("مشاهدة التفاصيل"),
                  ),
                ),
              ],
            ),
          if (request.status == "SENT") // Show buttons only for SENT status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAccept(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text("مشاهدة التفاصيل"),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
