import 'package:flutter/material.dart';
import '../../../models/quiz_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _answered = false;

  final List<QuizModel> _questions = [
    QuizModel(
      id: '1',
      question: 'ما هي اللغة الأساسية المستخدمة لتطوير تطبيقات Flutter؟',
      options: ['Java', 'Dart', 'Python', 'C++'],
      correctIndex: 1,
      explanation: 'لغة Dart هي اللغة الرسمية والأساسية في Flutter.',
    ),
    QuizModel(
      id: '2',
      question: 'أي من الأتي يُستخدم لإدارة الحالة في فلاتر؟',
      options: ['BLoC', 'Container', 'SizedBox', 'Scaffold'],
      correctIndex: 0,
      explanation: 'نظام BLoC يُعتبر من أشهر أدوات إدارة الحالة.',
    ),
    QuizModel(
      id: '3',
      question: 'ما هو الملف المسؤول عن تعريف الحزم والتبعيات؟',
      options: [
        'main.dart',
        'pubspec.yaml',
        'analysis_options.yaml',
        'README.md',
      ],
      correctIndex: 1,
      explanation: 'ملف pubspec.yaml هو الأساس لإدارة الحزم في المشروع.',
    ),
    QuizModel(
      id: '4',
      question: 'ما هو الـ Widget المسؤول عن القوائم الطويلة بكفاءة؟',
      options: ['Column', 'Row', 'ListView.builder', 'Container'],
      correctIndex: 2,
      explanation: 'ListView.builder يبني العناصر المرئية فقط لتحسين الأداء.',
    ),
  ];

  void _answerQuestion(int index) {
    if (_answered) return;
    setState(() {
      _selectedAnswerIndex = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _answered = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: _score, total: _questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];
    double progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('السؤال ${_currentIndex + 1} من ${_questions.length}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                currentQ.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(currentQ.options.length, (index) {
              Color buttonColor = Colors.white;
              Color textColor = Colors.black87;

              if (_answered) {
                if (index == currentQ.correctIndex) {
                  buttonColor = Colors.green.shade100;
                  textColor = Colors.green.shade800;
                } else if (index == _selectedAnswerIndex) {
                  buttonColor = Colors.red.shade100;
                  textColor = Colors.red.shade800;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onPressed: () => _answerQuestion(index),
                  child: Text(
                    currentQ.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            if (_answered)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'التوضيح: ${currentQ.explanation}',
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 14),
                ),
              ),

            const Spacer(),

            if (_answered)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex == _questions.length - 1
                      ? 'عرض النتيجة'
                      : 'السؤال التالي',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
