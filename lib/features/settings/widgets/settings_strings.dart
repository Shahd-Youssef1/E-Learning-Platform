/// Strings and translations for Settings Screen (Arabic & English)
class SettingsStrings {
  final bool isArabic;
  const SettingsStrings({this.isArabic = true});

  // App Bar & Sections
  String get title => isArabic ? 'الإعدادات' : 'Settings';
  String get rootScreenFeedback => isArabic ? 'أنت بالفعل في الشاشة الرئيسية للإعدادات' : 'You are already on the settings screen';
  String get preferences => isArabic ? 'التفضيلات' : 'Preferences';
  String get account => isArabic ? 'الحساب' : 'Account';
  String get support => isArabic ? 'الدعم' : 'Support';

  // Preferences items & Feedback
  String get darkMode => isArabic ? 'الوضع الداكن' : 'Dark Mode';
  String get darkModeOn => isArabic ? 'تم تفعيل الوضع الداكن 🌙' : 'Dark Mode enabled 🌙';
  String get darkModeOff => isArabic ? 'تم تفعيل الوضع النهاري (Light Mode) ☀️' : 'Light Mode enabled ☀️';
  String get notifications => isArabic ? 'إشعارات التطبيق' : 'App Notifications';
  String get notificationsOn => isArabic ? 'تم تفعيل الإشعارات' : 'Notifications enabled';
  String get notificationsOff => isArabic ? 'تم كتم الإشعارات' : 'Notifications muted';
  String get studyReminder => isArabic ? 'تذكير الدراسة اليومي' : 'Daily Study Reminder';
  String get reminderOn => isArabic ? 'تم ضبط تذكير الدراسة اليومي (08:00 م)' : 'Daily reminder set for 08:00 PM';
  String get reminderOff => isArabic ? 'تم إيقاف تذكير الدراسة' : 'Daily reminder turned off';
  String get wifiOnly => isArabic ? 'التحميل عبر Wi-Fi فقط' : 'Download via Wi-Fi only';
  String get wifiOnlyOn => isArabic ? 'سيتم التحميل عبر Wi-Fi فقط لتوفير البيانات' : 'Downloads will use Wi-Fi only';
  String get wifiOnlyOff => isArabic ? 'تم السماح بالتحميل عبر بيانات الهاتف' : 'Cellular downloads enabled';

  // Account
  String get language => isArabic ? 'اللغة' : 'Language';
  String get editProfile => isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile';
  String get privacySecurity => isArabic ? 'الخصوصية والأمان' : 'Privacy & Security';
  String get subscriptionPayment => isArabic ? 'الاشتراك والدفع' : 'Subscription & Payment';

  // Support
  String get helpCenter => isArabic ? 'مركز المساعدة' : 'Help Center';
  String get contactUs => isArabic ? 'تواصل معنا' : 'Contact Us';
  String get rateApp => isArabic ? 'قيّم التطبيق' : 'Rate App';

  // Dialogs: Language & Profile
  String get chooseLanguage => isArabic ? 'اختر لغة التطبيق' : 'Choose App Language';
  String get saveChanges => isArabic ? 'حفظ التعديلات' : 'Save Changes';
  String get changesSaved => isArabic ? 'تم حفظ التعديلات بنجاح!' : 'Changes saved successfully!';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get emailAddress => isArabic ? 'البريد الإلكتروني' : 'Email Address';

  // Dialogs: Privacy & Delete
  String get changePassword => isArabic ? 'تغيير كلمة المرور' : 'Change Password';
  String get passwordSubtitle => isArabic ? 'آخر تحديث منذ 3 أشهر' : 'Last updated 3 months ago';
  String get passwordResetSent => isArabic ? 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك' : 'Password reset link sent to your email';
  String get deleteAccount => isArabic ? 'حذف الحساب نهائياً' : 'Delete Account Permanently';
  String get deleteAccountConfirmTitle => isArabic ? 'تأكيد حذف الحساب' : 'Confirm Account Deletion';
  String get deleteAccountConfirmMessage => isArabic
      ? 'هل أنت متأكد من رغبتك في حذف الحساب نهائياً؟ سيتم مسح كافة البيانات والكورسات والشهادات المرتبطة به ولن تتمكن من استعادتها.'
      : 'Are you sure you want to permanently delete your account? All associated courses and certificates will be lost.';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get yesDelete => isArabic ? 'نعم، احذف' : 'Yes, Delete';
  String get deleteRequestReceived => isArabic ? 'تم استلام طلب حذف الحساب بنجاح.' : 'Account deletion request received.';

  // Help Center
  String get helpCenterTitle => isArabic ? 'مركز المساعدة والأسئلة الشائعة' : 'Help Center & FAQ';
  String get searchFaq => isArabic ? 'ابحث عن إجابة لسؤالك...' : 'Search for answers...';
  String get faq1Q => isArabic ? 'كيف يمكنني تحميل الدروس للمشاهدة بدون إنترنت؟' : 'How do I download lessons for offline viewing?';
  String get faq1A => isArabic ? 'يمكنك الضغط على أيقونة التحميل بجوار أي درس داخل الكورس للوصول إليه في أي وقت دون اتصال بالإنترنت.' : 'Tap the download icon next to any lesson to access it anytime offline.';
  String get faq2Q => isArabic ? 'كيف أحصل على شهادة إتمام المسار؟' : 'How do I get my certificate of completion?';
  String get faq2A => isArabic ? 'بمجرد إكمال 100% من دروس المسار واجتياز الاختبار النهائي بدرجة 80% فأكثر، ستصدر شهادتك تلقائياً في قسم الشهادات.' : 'Complete 100% of course lessons and score 80%+ on the final exam to automatically generate your certificate.';
  String get faq3Q => isArabic ? 'هل يمكنني استرجاع مبلغ الاشتراك؟' : 'Can I request a refund?';
  String get faq3A => isArabic ? 'نعم، نقدم ضمان استرداد كامل للأموال خلال 14 يوماً من بدء الاشتراك في حال لم تكن راضياً عن الخدمة.' : 'Yes, we offer a full 14-day money-back guarantee if you are not satisfied.';

  // Contact Us
  String get contactUsTitle => isArabic ? 'تواصل معنا' : 'Contact Us';
  String get contactUsSubtitle => isArabic ? 'فريق الدعم الفني جاهز لمساعدتك على مدار الساعة' : 'Our support team is available 24/7';
  String get liveChat => isArabic ? 'المحادثة المباشرة مع الدعم' : 'Live Chat Support';
  String get liveChatConnecting => isArabic ? 'جاري توصيلك بأحد ممثلي الدعم...' : 'Connecting you with support...';
  String get emailSupport => isArabic ? 'البريد الإلكتروني: support@eduflow.com' : 'Email: support@eduflow.com';
  String get emailCopied => isArabic ? 'تم نسخ البريد الإلكتروني للدعم' : 'Support email copied to clipboard';
  String get whatsappSupport => isArabic ? 'واتساب الدعم السريع' : 'Fast WhatsApp Support';
  String get openingWhatsapp => isArabic ? 'جاري فتح محادثة الدعم عبر واتساب...' : 'Opening WhatsApp support chat...';

  // Rate App
  String get rateAppTitle => isArabic ? 'قيّم تطبيق EduFlow' : 'Rate EduFlow App';
  String get rateAppSubtitle => isArabic ? 'رأيك يساعدنا على تطوير المنصة وتقديم الأفضل' : 'Your feedback helps us improve and deliver the best experience';
  String get feedbackHint => isArabic ? 'اكتب ملاحظاتك أو اقتراحاتك هنا (اختياري)...' : 'Write your feedback or suggestions (optional)...';
  String get later => isArabic ? 'لاحقاً' : 'Later';
  String get submitRating => isArabic ? 'إرسال التقييم' : 'Submit Review';
  String ratingSubmitted(int stars) => isArabic ? 'شكراً لك على تقييمك ($stars نجوم)! تم الإرسال بنجاح.' : 'Thank you for your rating ($stars stars)! Submitted successfully.';

  String sentimentText(int rating) {
    if (isArabic) {
      if (rating <= 2) return 'سنعمل جاهدين لتحسين تجربتك';
      if (rating == 3) return 'شكراً لك، نسعى للأفضل دائماً';
      if (rating == 4) return 'سعداء جداً بإعجابك بالتطبيق!';
      return 'شكراً لثقتك الغالية في EduFlow! 🌟';
    }
    if (rating <= 2) return 'We will work hard to improve your experience';
    if (rating == 3) return 'Thank you, we always strive for better';
    if (rating == 4) return 'Glad you enjoy using the app!';
    return 'Thank you for your trust in EduFlow! 🌟';
  }
}
