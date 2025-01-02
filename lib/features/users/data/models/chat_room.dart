class ChatRoom {
  final int id;
  final String name;
  final String state;
  final String currentUserState;
  final String otherUserState;
  final int currentUserMessageCount;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.currentUserState,
    required this.otherUserState,
    required this.currentUserMessageCount,
    required this.state,
    required this.createdAt,
  });

  /// Factory constructor to create a ChatRoom from JSON
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      currentUserMessageCount: json['current_user_message_count'] as int,
      name: json['name'],
      currentUserState: json['current_user_state'],
      otherUserState: json['other_user_state'],
      state: json['state'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Method to convert ChatRoom to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'current_user_state': currentUserState,
      'other_user_state': otherUserState,
      'state': state,
      'current_user_message_count': currentUserMessageCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
