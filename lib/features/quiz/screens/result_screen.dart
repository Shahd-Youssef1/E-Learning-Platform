import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    // رسالة تتغير حسب الدرجة (أكتر من نص الدرجة يبقى أداء رائع)
    String message = score > (total / 2)
        ? 'أداء رائع وممتاز! 🌟'
        : 'حاول مرة أخرى لتطوير مستواك! 💪';

    return Scaffold(
      appBar: AppBar(
        title: const Text('نتيجة الاختبار'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // أيقونة الكأس
            const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
            const SizedBox(height: 24),

            Text(
              'نتيجتك هي $score / $total',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // زرار إعادة الاختبار
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'إعادة الاختبار',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),

            // زرار العودة للرئيسية
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'العودة للرئيسية',
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
