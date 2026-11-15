import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../data/app_data.dart';
import '../models/course_model.dart';
import 'lesson_player_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final CourseModel? course;

  const CourseDetailsScreen({super.key, this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool isFavorite = false;
  int selectedTab = 0; // 0: الوصف, 1: المحتوى, 2: التعليقات

  final whatYouWillLearn = const [
    'بناء تطبيقات موبايل متكاملة من الصفر باحترافية',
    'تصميم واجهات مستخدم عصرية ومتجاوبة مع كل الشاشات',
    'التعامل مع البيانات وإدارة الحالة State Management',
    'رفع التطبيق على المتاجر وتجهيزه للاستخدام الفعلي',
  ];

  final requirements = const [
    'جهاز كمبيوتر أو لابتوب بمواصفات متوسطة',
    'أساسيات بسيطة في البرمجة (يفضل، وليس شرطاً)',
    'الرغبة في التطبيق العملي وبناء مشاريع حقيقية',
  ];

  final courseLessons = const [
    {'title': '01. مقدمة عن الكورس وأدوات العمل', 'duration': '10:30', 'isCompleted': true},
    {'title': '02. أساسيات بناء الواجهات Widgets', 'duration': '18:45', 'isCompleted': true},
    {'title': '03. إدارة الحالة State Management', 'duration': '22:15', 'isCompleted': false},
    {'title': '04. التعامل مع التنقل بين الشاشات Navigation', 'duration': '15:00', 'isCompleted': false},
    {'title': '05. ربط التطبيق بقاعدة البيانات', 'duration': '25:40', 'isCompleted': false},
  ];

  final reviews = const [
    {
      'name': 'سارة محمود',
      'rating': 5.0,
      'date': 'منذ يومين',
      'comment': 'شرح مبسط جداً ومنظم، التطبيق العملي في كل درس فرق معايا كتير.',
    },
    {
      'name': 'كريم طارق',
      'rating': 4.8,
      'date': 'منذ أسبوع',
      'comment': 'محتوى ممتاز ومغطي كل الأساسيات اللي محتاجها عشان أبدأ أعمل مشاريع لوحدي.',
    },
  ];

  CourseModel _resolveCourse(BuildContext context) {
    if (widget.course != null) return widget.course!;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CourseModel) return args;
    return CourseModel.fromJson(AppData.courses.first);
  }

  void _openPlayer(CourseModel course, {int lessonIndex = 2}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonPlayerScreen(
          course: course,
          initialLessonIndex: lessonIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = _resolveCourse(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => Navigator.maybePop(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          title: const Text(
            'تفاصيل الكورس',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'تمت إضافة الكورس إلى المفضلة ❤️'
                            : 'تمت إزالة الكورس من المفضلة',
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: AppColors.primaryDark,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.danger : AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة المعاينة + زرار تشغيل يوديكي للمشغل
                    GestureDetector(
                      onTap: () => _openPlayer(course),
                      child: Container(
                        height: 190,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  course.category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const Positioned(
                              bottom: 14,
                              child: Text(
                                'معاينة الكورس',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // العنوان والتقييم والمحاضر والساعات
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 14,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.warning, size: 19),
                            const SizedBox(width: 4),
                            Text(
                              '${course.rating}',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_outline_rounded,
                                color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              course.instructor,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_rounded,
                                color: AppColors.primary, size: 17),
                            const SizedBox(width: 4),
                            Text(
                              '${course.hours} ساعة',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 3 تبويبات تتغير عند الضغط (الوصف - المحتوى - التعليقات)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton('الوصف', 0),
                          _buildTabButton('المحتوى', 1),
                          _buildTabButton('التعليقات', 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    if (selectedTab == 0) _buildDescriptionTab(course),
                    if (selectedTab == 1) _buildContentTab(course),
                    if (selectedTab == 2) _buildReviewsTab(),
                  ],
                ),
              ),
            ),

            // زرار ابدأ التعلم الآن يوديكي للمشغل
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _openPlayer(course),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'ابدأ التعلم الآن',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(CourseModel course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${course.description} في هذا الكورس ستتعلم خطوة بخطوة كيفية بناء تطبيقات احترافية بأسلوب عملي مبسط.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            _buildStatCard(Icons.play_lesson_rounded, '${course.lessons}', 'درس'),
            const SizedBox(width: 10),
            _buildStatCard(Icons.schedule_rounded, '${course.hours}', 'ساعة'),
            const SizedBox(width: 10),
            _buildStatCard(Icons.star_rounded, '${course.rating}', 'التقييم'),
          ],
        ),
        const SizedBox(height: 14),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBadge(Icons.signal_cellular_alt_rounded, 'المستوى: ${course.level}'),
            _buildBadge(Icons.language_rounded, 'اللغة: العربية'),
            _buildBadge(Icons.workspace_premium_rounded, 'شهادة إتمام'),
          ],
        ),
        const SizedBox(height: 20),

        const Text(
          'ماذا ستتعلم؟',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: whatYouWillLearn.map((point) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'المحاضر',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.surfacePurple,
                child: Text(
                  course.instructor.isNotEmpty ? course.instructor[0] : 'M',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.instructor,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'مدرب معتمد في مجال ${course.category}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          'المتطلبات',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...requirements.map(
              (req) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 7, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    req,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfacePurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab(CourseModel course) {
    return Column(
      children: courseLessons.asMap().entries.map((entry) {
        final index = entry.key;
        final lesson = entry.value;
        final bool isCompleted = lesson['isCompleted'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              onTap: () => _openPlayer(course, lessonIndex: index),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.surfacePurple,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
                  color: isCompleted ? AppColors.success : AppColors.primary,
                  size: 20,
                ),
              ),
              title: Text(
                lesson['title'] as String,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                lesson['duration'] as String,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewsTab() {
    return Column(
      children: reviews.map((review) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.surfacePurple,
                    child: Text(
                      (review['name'] as String)[0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['name'] as String,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          review['date'] as String,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                      const SizedBox(width: 3),
                      Text(
                        '${review['rating']}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                review['comment'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}