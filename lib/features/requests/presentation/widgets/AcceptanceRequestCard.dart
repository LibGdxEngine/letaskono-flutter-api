import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sender: ${request.sender}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Receiver: ${request.receiver}"),
            const SizedBox(height: 8),
            Text("Timestamp: ${request.timestamp}"),
            const SizedBox(height: 8),
            Text("Status: ${request.status}"),
            const SizedBox(height: 16),
            if (request.status == "SENT") // Show buttons only for SENT status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => onAccept(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Accept"),
                  ),
                  ElevatedButton(
                    onPressed: () => onReject(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Reject"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
