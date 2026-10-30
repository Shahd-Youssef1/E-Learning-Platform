class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'].toString(),
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      correctIndex: (json['correct_index'] ?? json['correctIndex']) as int,
      explanation: json['explanation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_index': correctIndex,
      'explanation': explanation,
    };
  }
}
