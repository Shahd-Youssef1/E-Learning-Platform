import '../../../data/app_data.dart';
import '../../../models/certificate_model.dart';
import '../../../models/course_model.dart';

/// بيانات التعلّم الخاصة بالمستخدم (الكورسات المسجّل فيها + الشهادات)
/// وكل الإحصائيات بتتحسب منها، مفيش أرقام ثابتة.
class LearningData {
  final List<CourseModel> courses;
  final List<CertificateModel> certificates;

  const LearningData({required this.courses, required this.certificates});

  int get coursesCount => courses.length;

  /// مجموع الدروس المكتملة = عدد دروس كل كورس × نسبة تقدمه.
  int get completedLessons =>
      courses.fold<int>(0, (sum, c) => sum + (c.lessons * c.progress / 100).round());

  /// ساعات التعلم = ساعات كل كورس × نسبة تقدمه.
  int get learningHours =>
      courses.fold<double>(0, (sum, c) => sum + c.hours * c.progress / 100).round();

  /// متوسط تقدم الكورسات المسجّل فيها (0 - 100).
  int get averageProgress => courses.isEmpty
      ? 0
      : (courses.fold<int>(0, (sum, c) => sum + c.progress) / courses.length)
          .round();

  bool get hasCompletedCourse => courses.any((c) => c.progress >= 100);

  /// أحدث شهادة (أو null لو مفيش).
  CertificateModel? get latestCertificate {
    if (certificates.isEmpty) return null;
    final sorted = [...certificates]..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first;
  }
}

class LearningRepository {
  const LearningRepository._();

  /// TODO(backend): استبدلي AppData بـ Supabase (جدول enrollments و
  /// certificates مفلتر على المستخدم الحالي). المصدر الحالي هو نفس بيانات
  /// باقي شاشات المشروع، وباقي الكود مش هيتغير لما المصدر يتبدّل.
  static Future<LearningData> load() async {
    final courses = AppData.courses
        .map(CourseModel.fromJson)
        .where((c) => c.progress > 0)
        .toList();
    final certificates =
        AppData.certificates.map(CertificateModel.fromJson).toList();
    return LearningData(courses: courses, certificates: certificates);
  }
}

const List<String> _arabicMonths = [
  'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
];

/// "صدرت في سبتمبر 2026 · EF-001"
String certificateIssuedLabel(CertificateModel c) {
  final d = DateTime.tryParse(c.date);
  if (d == null) return c.id;
  return 'صدرت في ${_arabicMonths[d.month - 1]} ${d.year} · ${c.id}';
}
