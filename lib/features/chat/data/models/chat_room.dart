import 'female_user_summary.dart';
import 'male_user_summary.dart';

class ChatRoom {
  final int id;
  final String name;
  final int? male;
  final int? female;
  final int? currentUserCode;
  final List<int>? admins;
  final String state;
  final String createdAt;
  final int maleMessageCount;
  final int femaleMessageCount;
  final MaleUserSummary? maleSummary;
  final FemaleUserSummary? femaleSummary;
  final String maleState;
  final String femaleState;

  ChatRoom({
    required this.id,
    required this.name,
    this.male,
    this.female,
    this.currentUserCode,
    this.admins,
    this.maleSummary,
    this.femaleSummary,
    required this.state,
    required this.createdAt,
    required this.maleMessageCount,
    required this.femaleMessageCount,
    required this.maleState,
    required this.femaleState,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    print(json['male_summary']);
    return ChatRoom(
      id: json['id'] as int,
      name: json['name'] as String,
      male: json['male'] is int ? json['male'] as int : null,
      female: json['female'] is int ? json['female'] as int : null,
      currentUserCode: json['current_user_code'] as int?,
      admins: List<int>.from(json['admins'] ?? []), // Handle null or empty list
      state: json['state'] as String,
      createdAt: json['created_at'] as String,
      maleMessageCount: json['male_message_count'] as int,
      femaleMessageCount: json['female_message_count'] as int,
      maleState: json['male_state'] as String,
      femaleState: json['female_state'] as String,
      maleSummary: json['male'] is Map<String, dynamic>
          ? MaleUserSummary.fromJson(json['male'])
          : null,
      femaleSummary: json['female'] is Map<String, dynamic>
          ? FemaleUserSummary.fromJson(json['female'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'male': male,
      'female': female,
      'current_user_code': currentUserCode,
      'admins': admins,
      'state': state,
      'created_at': createdAt,
      'male_message_count': maleMessageCount,
      'female_message_count': femaleMessageCount,
      'male_state': maleState,
      'female_state': femaleState,
      'male_summary': maleSummary?.toJson(),
      'female_summary': femaleSummary?.toJson(),
    };
  }

}

