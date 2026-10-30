class AppData {
  // User Information
  static const Map<String, dynamic> user = {
    'id': 'U001',
    'name': 'Ahmed Mohamed',
    'email': 'ahmed@gmail.com',
    'isPro': true,
    'image': '',
  };

  // Courses
  static const List<Map<String, dynamic>> courses = [
    {
      'id': 1,
      'title': 'Flutter Development',
      'instructor': 'Ahmed Ali',
      'category': 'Programming',
      'rating': 4.8,
      'level': 'Beginner',
      'hours': 20,
      'lessons': 30,
      'progress': 60,
      'description': 'Learn Flutter and build mobile applications.',
    },
    {
      'id': 2,
      'title': 'UI/UX Design',
      'instructor': 'Sara Mohamed',
      'category': 'Design',
      'rating': 4.9,
      'level': 'Beginner',
      'hours': 15,
      'lessons': 24,
      'progress': 35,
      'description': 'Learn user interface and user experience design.',
    },
    {
      'id': 3,
      'title': 'Digital Marketing',
      'instructor': 'Omar Hassan',
      'category': 'Marketing',
      'rating': 4.7,
      'level': 'Intermediate',
      'hours': 18,
      'lessons': 26,
      'progress': 20,
      'description': 'Learn digital marketing strategies.',
    },
    {
      'id': 4,
      'title': 'Python Programming',
      'instructor': 'Mona Ahmed',
      'category': 'Programming',
      'rating': 4.8,
      'level': 'Beginner',
      'hours': 22,
      'lessons': 32,
      'progress': 0,
      'description': 'Learn Python programming from scratch.',
    },
    {
      'id': 5,
      'title': 'Data Analysis',
      'instructor': 'Mohamed Samir',
      'category': 'Data',
      'rating': 4.6,
      'level': 'Intermediate',
      'hours': 25,
      'lessons': 35,
      'progress': 45,
      'description': 'Learn data analysis and visualization.',
    },
    {
      'id': 6,
      'title': 'Graphic Design',
      'instructor': 'Nour Adel',
      'category': 'Design',
      'rating': 4.9,
      'level': 'Beginner',
      'hours': 16,
      'lessons': 22,
      'progress': 0,
      'description': 'Learn graphic design fundamentals.',
    },
  ];

  // Notifications
  static const List<Map<String, dynamic>> notifications = [
    {
      'id': 1,
      'title': 'Course Update',
      'message': 'A new lesson has been added to Flutter Development.',
      'time': '5 min ago',
      'isRead': false,
    },
    {
      'id': 2,
      'title': 'New Achievement',
      'message': 'Congratulations! You completed 10 lessons.',
      'time': '1 hour ago',
      'isRead': false,
    },
    {
      'id': 3,
      'title': 'Study Reminder',
      'message': 'It is time to continue your learning journey.',
      'time': '3 hours ago',
      'isRead': false,
    },
    {
      'id': 4,
      'title': 'New Course',
      'message': 'Check out our new UI/UX Design course.',
      'time': 'Yesterday',
      'isRead': true,
    },
    {
      'id': 5,
      'title': 'Welcome',
      'message': 'Welcome to EduFlow!',
      'time': '2 days ago',
      'isRead': true,
    },
  ];

  // Quiz Questions
  static const List<Map<String, dynamic>> quizQuestions = [
    {
      'question': 'What is Flutter?',
      'options': [
        'A programming language',
        'A UI framework',
        'A database',
        'An operating system',
      ],
      'correctIndex': 1,
      'explanation': 'Flutter is a UI framework by Google.',
    },
    {
      'question': 'Which language is used with Flutter?',
      'options': ['Java', 'Python', 'Dart', 'C++'],
      'correctIndex': 2,
      'explanation': 'Flutter applications are developed using Dart.',
    },
    {
      'question': 'What is a Widget in Flutter?',
      'options': [
        'A database table',
        'A building block of the UI',
        'A programming language',
        'A server',
      ],
      'correctIndex': 1,
      'explanation': 'Widgets are the basic building blocks of Flutter UI.',
    },
    {
      'question': 'Which widget creates a vertical layout?',
      'options': ['Row', 'Stack', 'Column', 'Container'],
      'correctIndex': 2,
      'explanation': 'Column arranges its children vertically.',
    },
  ];

  // Certificates
  static const List<Map<String, dynamic>> certificates = [
    {
      'id': 'EF-001',
      'student': 'Ahmed Mohamed',
      'course': 'Flutter Development',
      'date': '2026-09-15',
    },
    {
      'id': 'EF-002',
      'student': 'Ahmed Mohamed',
      'course': 'UI/UX Design',
      'date': '2026-08-20',
    },
    {
      'id': 'EF-003',
      'student': 'Ahmed Mohamed',
      'course': 'Python Programming',
      'date': '2026-07-10',
    },
  ];
}
