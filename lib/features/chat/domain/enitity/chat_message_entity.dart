class ChatMessageEntity {
  final int id;
  final String content;
  final int senderId;
  final String type;
  final String timestamp;
  final bool isRead;

  ChatMessageEntity({
    required this.id,
    required this.content,
    required this.senderId,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  /// Factory method to create a `ChatMessage` instance from a JSON object
  factory ChatMessageEntity.fromJson(Map<String, dynamic> data) {
    return ChatMessageEntity(
      id: data['id'] as int,
      content: data['content'] as String,
      senderId: data['sender'] as int,
      isRead: data['is_read'] as bool,
      type: data['type'] as String,
      timestamp: data['timestamp'] as String,
    );
  }

  /// Method to convert a `ChatMessage` instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'timestamp': timestamp,
      'is_read': isRead,
    };
  }
}
