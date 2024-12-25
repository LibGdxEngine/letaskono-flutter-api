class ChatRoomEntity {
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
  final String maleState;
  final String femaleState;

  ChatRoomEntity({
    required this.id,
    required this.name,
    this.male,
    this.female,
    this.currentUserCode,
    this.admins,
    required this.state,
    required this.createdAt,
    required this.maleMessageCount,
    required this.femaleMessageCount,
    required this.maleState,
    required this.femaleState,
  });

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) {
    return ChatRoomEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      male: json['male'] as int?,
      female: json['female'] as int?,
      currentUserCode: json['current_user_code'] as int?,
      admins: List<int>.from(json['admins'] ?? ''), // Handle null or empty list
      state: json['state'] as String,
      createdAt: json['created_at'] as String,
      maleMessageCount: json['male_message_count'] as int,
      femaleMessageCount: json['female_message_count'] as int,
      maleState: json['male_state'] as String,
      femaleState: json['female_state'] as String,
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
    };
  }
}