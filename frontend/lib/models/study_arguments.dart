import 'package:frontend/models/flashcard.dart';

class StudyArguments {
  final String setId;
  final List<Flashcard> flashcards;
  final bool repeatUnknown;

  StudyArguments({
    required this.setId,
    required this.flashcards,
    required this.repeatUnknown,
  });
}