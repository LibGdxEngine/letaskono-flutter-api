import 'package:letaskono_flutter/features/requests/data/models/profile.dart';
import 'package:letaskono_flutter/features/requests/data/models/request_type.dart';

class AcceptanceRequest {
  final int id;
  final Profile sender;
  final Profile receiver;
  final String timestamp;
  final String status;
  final RequestType requestType;

  AcceptanceRequest({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.status,
    required this.requestType,
  });

  factory AcceptanceRequest.fromJson(
      Map<String, dynamic> json, RequestType type) {
    return AcceptanceRequest(
      id: json['id'],
      sender: Profile.fromJson(json['sender']),
      receiver: Profile.fromJson(json['receiver']),
      timestamp: json['timestamp'],
      status: json['status'],
      requestType: type,
    );
  }
}
