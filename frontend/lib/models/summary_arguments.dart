import 'dart:ui';

import 'package:frontend/models/flashcard.dart';

class SummaryArguments {
  final int knownCount;
  final int unknownCount;
  final VoidCallback onRepeatUnknown;
  final VoidCallback onRepeatAll;
  final VoidCallback onFinish;
  final List<Flashcard> flashcards;
  late List<bool?> flashcardStatus;

  SummaryArguments({
    required this.knownCount,
    required this.unknownCount,
    required this.onRepeatUnknown,
    required this.onRepeatAll,
    required this.onFinish,
    required this.flashcards,
    required this.flashcardStatus,
  });
}