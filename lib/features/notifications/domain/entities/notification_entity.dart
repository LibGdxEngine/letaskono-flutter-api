class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  // Factory constructor to create a Notification object from JSON
  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      isRead: json['is_read'],
    );
  }

  // Method to convert a Notification object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}
