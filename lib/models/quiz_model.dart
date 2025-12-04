class QuizModel {
  final String id;
  final String conceptId;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String lang;

  QuizModel({
    required this.id,
    required this.conceptId,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.lang,
  });
}
