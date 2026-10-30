class CertificateModel {
  final String id;
  final String student;
  final String course;
  final String date;

  const CertificateModel({
    required this.id,
    required this.student,
    required this.course,
    required this.date,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'].toString(),
      student: json['student'] as String,
      course: json['course'] as String,
      date: json['date'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'student': student, 'course': course, 'date': date};
  }
}
