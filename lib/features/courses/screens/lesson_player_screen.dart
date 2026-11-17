import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../data/app_data.dart';
import '../../../models/course_model.dart';

class LessonPlayerScreen extends StatefulWidget {
  final CourseModel? course;
  final int initialLessonIndex;

  const LessonPlayerScreen({
    super.key,
    this.course,
    this.initialLessonIndex = 2,
  });

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  bool isPlaying = false;
  bool isSaved = false;
  double videoProgress = 0.35;
  late int currentLessonIndex;
  final TextEditingController _notesController = TextEditingController();

  final sectionLessons = [
    {
      'title': 'الدرس 01: مقدمة وتهيئة بيئة العمل',
      'section': 'القسم الأول: الأساسيات',
      'duration': '10:30',
      'status': 'completed',
    },
    {
      'title': 'الدرس 02: بناء الواجهات الأساسية',
      'section': 'القسم الأول: الأساسيات',
      'duration': '14:20',
      'status': 'completed',
    },
    {
      'title': 'الدرس 03: إدارة الحالة State Management',
      'section': 'القسم الأول: الأساسيات',
      'duration': '18:00',
      'status': 'current',
    },
    {
      'title': 'الدرس 04: التعامل مع القوائم والبيانات',
      'section': 'القسم الأول: الأساسيات',
      'duration': '16:45',
      'status': 'locked',
    },
    {
      'title': 'الدرس 05: تطبيق عملي شامل',
      'section': 'القسم الأول: الأساسيات',
      'duration': '22:10',
      'status': 'locked',
    },
  ];

  @override
  void initState() {
    super.initState();
    currentLessonIndex = widget.initialLessonIndex;
    _syncLessonStatuses();
  }

  void _syncLessonStatuses() {
    for (int i = 0; i < sectionLessons.length; i++) {
      if (i < currentLessonIndex) {
        sectionLessons[i]['status'] = 'completed';
      } else if (i == currentLessonIndex) {
        sectionLessons[i]['status'] = 'current';
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  CourseModel _resolveCourse(BuildContext context) {
    if (widget.course != null) return widget.course!;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CourseModel) return args;
    return CourseModel.fromJson(AppData.courses.first);
  }

  void _showSnackMessage(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  String _formatCurrentTime() {
    const int totalSeconds = 18 * 60;
    final int currentSeconds = (totalSeconds * videoProgress).round();
    final String mins = (currentSeconds ~/ 60).toString().padLeft(2, '0');
    final String secs = (currentSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _goToNextLesson() {
    if (currentLessonIndex < sectionLessons.length - 1) {
      setState(() {
        sectionLessons[currentLessonIndex]['status'] = 'completed';
        currentLessonIndex++;
        sectionLessons[currentLessonIndex]['status'] = 'current';
        videoProgress = 0.0;
        isPlaying = true;
      });
      _showSnackMessage('تم الانتقال إلى ${sectionLessons[currentLessonIndex]['title']}');
    } else {
      _showSnackMessage('أحسنت! لقد أنهيت جميع دروس هذا القسم 🎉');
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = _resolveCourse(context);
    final currentLesson = sectionLessons[currentLessonIndex];

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
          title: Text(
            course.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // مساحة الفيديو + زرار تشغيل/إيقاف يتبدل + شريط تقدم والوقت
                    Container(
                      height: 210,
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.primary],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                                  thumbColor: Colors.white,
                                ),
                                child: Slider(
                                  value: videoProgress,
                                  onChanged: (val) {
                                    setState(() {
                                      videoProgress = val;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatCurrentTime(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    Text(
                                      currentLesson['duration'] ?? '18:00',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      currentLesson['title'] ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentLesson['section'] ?? '',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3 أزرار (تحميل، اسأل المحاضر، حفظ)
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.download_rounded,
                          label: 'تحميل',
                          onTap: () => _showSnackMessage('جاري تحميل الدرس للمشاهدة بدون إنترنت...'),
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'اسأل المحاضر',
                          onTap: () => _showSnackMessage(
                            'تم فتح نافذة التواصل مع المحاضر ${course.instructor}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildActionButton(
                          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          label: isSaved ? 'محفوظ' : 'حفظ',
                          isActive: isSaved,
                          onTap: () {
                            setState(() => isSaved = !isSaved);
                            _showSnackMessage(
                              isSaved
                                  ? 'تم حفظ الدرس في قائمة المحفوظات'
                                  : 'تمت إزالة الدرس من المحفوظات',
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // دروس القسم (مكتمل، الحالي، مقفول)
                    const Text(
                      'دروس القسم',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...sectionLessons.asMap().entries.map((entry) {
                      final index = entry.key;
                      final lesson = entry.value;
                      final String status = lesson['status'] ?? 'locked';
                      final bool isCompleted = status == 'completed';
                      final bool isCurrent = status == 'current';
                      final bool isLocked = status == 'locked';

                      return GestureDetector(
                        onTap: () {
                          if (isLocked) {
                            _showSnackMessage('هذا الدرس مقفول، أكمل الدرس الحالي أولاً 🔒');
                          } else {
                            setState(() {
                              currentLessonIndex = index;
                              _syncLessonStatuses();
                              videoProgress = 0.0;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.surfacePurple : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isCurrent ? AppColors.primary : AppColors.border,
                              width: isCurrent ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppColors.success.withValues(alpha: 0.15)
                                      : isCurrent
                                      ? AppColors.primary
                                      : AppColors.surfaceSecondary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCompleted
                                      ? Icons.check_circle_rounded
                                      : isCurrent
                                      ? Icons.play_arrow_rounded
                                      : Icons.lock_outline_rounded,
                                  color: isCompleted
                                      ? AppColors.success
                                      : isCurrent
                                      ? Colors.white
                                      : AppColors.textMuted,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  lesson['title'] ?? '',
                                  style: TextStyle(
                                    color: isLocked
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary,
                                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                              Text(
                                lesson['duration'] ?? '',
                                style: TextStyle(
                                  color: isCurrent ? AppColors.primary : AppColors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // كارت ملاحظاتي
                    const Text(
                      'ملاحظاتي',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'اكتب ملاحظاتك المهمة حول هذا الدرس هنا...',
                              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                _showSnackMessage('تم حفظ ملاحظتك بنجاح ✅');
                              },
                              icon: const Icon(Icons.save_outlined, size: 18),
                              label: const Text('حفظ الملاحظة'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // زرار الدرس التالي
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _goToNextLesson,
                  icon: const Icon(Icons.skip_next_rounded),
                  label: const Text(
                    'الدرس التالي',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surfacePurple : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.textPrimary,
                size: 21,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}