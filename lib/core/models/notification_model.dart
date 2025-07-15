class UserNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String userId;
  final String? slotId;
  final String target;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? expiresAt;

  UserNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.userId,
    this.slotId,
    required this.target,
    required this.createdAt,
    required this.updatedAt,
    this.expiresAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      userId: json['userId'],
      slotId: json['slotId'],
      target: json['target'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt']) : null,
    );
  }
} 