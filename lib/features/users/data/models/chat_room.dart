class ChatRoom {
  final int id;
  final String name;
  final String state;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.state,
    required this.createdAt,
  });

  /// Factory constructor to create a ChatRoom from JSON
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Method to convert ChatRoom to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
