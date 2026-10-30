class CourseModel {
  final int id;
  final String title;
  final String instructor;
  final String category;
  final double rating;
  final String level;
  final int hours;
  final int lessons;
  final int progress;
  final String description;

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.rating,
    required this.level,
    required this.hours,
    required this.lessons,
    required this.progress,
    required this.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      instructor: json['instructor'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      level: json['level'] as String,
      hours: json['hours'] as int,
      lessons: json['lessons'] as int,
      progress: json['progress'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'category': category,
      'rating': rating,
      'level': level,
      'hours': hours,
      'lessons': lessons,
      'progress': progress,
      'description': description,
    };
  }
}
