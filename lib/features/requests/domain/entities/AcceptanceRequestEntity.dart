import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/features/requests/data/models/request_type.dart';

class AcceptanceRequestEntity extends Equatable {
  final int id;
  final String sender;
  final String receiver;
  final String timestamp;
  final String status;
  final RequestType requestType;

  AcceptanceRequestEntity({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.status,
    required this.requestType,
  });

  factory AcceptanceRequestEntity.fromJson(
      Map<String, dynamic> json, RequestType type) {
    return AcceptanceRequestEntity(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: json['timestamp'],
      status: json['status'],
      requestType: type,
    );
  }

  @override
  List<Object?> get props => [id];
}
