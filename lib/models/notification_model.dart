class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      message: json['message'] as String,
      time: json['time'].toString(),
      isRead: (json['is_read'] ?? json['isRead']) as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'is_read': isRead,
    };
  }
}
