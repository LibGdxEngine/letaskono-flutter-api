import 'package:letaskono_flutter/features/requests/data/models/request_type.dart';
import 'package:letaskono_flutter/features/users/data/models/chat_room.dart';

class AcceptanceRequest {
  final int id;
  final String timestamp;
  final int senderPkid;
  final int receiverPkid;
  String status;
  final ChatRoom? chatRoom;

  AcceptanceRequest({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.senderPkid,
    required this.receiverPkid,
    this.chatRoom,
  });

  factory AcceptanceRequest.fromJson(Map<String, dynamic> json) {
    return AcceptanceRequest(
      id: json['id'],
      timestamp: json['timestamp'],
      senderPkid: json['sender'],
      receiverPkid: json['receiver'],
      status: json['status'],
      chatRoom: json['chat_room'] != null
          ? ChatRoom.fromJson(json['chat_room'])
          : null,
    );
  }
}
