import 'package:flutter/material.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/flashcard.dart';
import 'package:frontend/models/summary_arguments.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  const FlashcardStudyScreen({super.key, required this.flashcards});

  @override
  FlashcardStudyScreenState createState() => FlashcardStudyScreenState();
}

class FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  late List<Flashcard> remainingFlashcards;
  late List<Flashcard> allFlashcards;
  late List<bool?> flashcardStatus;
  Flashcard? currentFlashcard;
  bool isFront = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    allFlashcards = List.from(widget.flashcards);
    flashcardStatus = List.filled(widget.flashcards.length, null);
    _initializeFlashcards();
  }

  void _initializeFlashcards() {
    setState(() {
      remainingFlashcards = List.from(allFlashcards);
      remainingFlashcards.shuffle();
      currentIndex = 0;
      _pickRandomFlashcard();
    });
  }

  void _pickRandomFlashcard() {
    if (currentIndex >= remainingFlashcards.length) {
      _showSummary();
      return;
    }
    setState(() {
      currentFlashcard = remainingFlashcards[currentIndex];
      isFront = true;
    });
  }

  void _markAsKnown(bool isKnown) {
    if (currentFlashcard != null) {
      final originalIndex = allFlashcards.indexOf(currentFlashcard!);
      flashcardStatus[originalIndex] = isKnown;
      currentIndex++;
      _pickRandomFlashcard();
    }
  }

  void _toggleCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  void _showSummary() {
    final knownCount = flashcardStatus.where((status) => status == true).length;
    final unknownCount = flashcardStatus.where((status) => status == false).length;

    Navigator.pushNamed(
      context,
      '/summary',
      arguments: SummaryArguments(
        knownCount: knownCount,
        unknownCount: unknownCount,
        onRepeatUnknown: _repeatUnknown,
        onRepeatAll: _repeatAll,
        onFinish: _finishStudy,
        flashcards: allFlashcards,
        flashcardStatus: flashcardStatus,
      ),
    );
  }

  void _repeatAll() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardStudyScreen(flashcards: allFlashcards),
      ),
    );
  }

  void _repeatUnknown() {
    final List<Flashcard> unknownFlashcards = [];
    for (int i = 0; i < allFlashcards.length; i++) {
      if (flashcardStatus[i] == false) {
        unknownFlashcards.add(allFlashcards[i]);
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardStudyScreen(flashcards: unknownFlashcards),
      ),
    );
  }

  Future<void> _finishStudy() async {
    await Navigator.pushNamed(
      context,
      '/home',
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: List.generate(
          remainingFlashcards.length,
          (index) {
            Color color;
            if (index < currentIndex) {
              final originalIndex = allFlashcards.indexOf(remainingFlashcards[index]);
              if (flashcardStatus[originalIndex] == true) {
                color = Colors.green;
              } else if (flashcardStatus[originalIndex] == false) {
                color = Colors.red;
              } else {
                color = Colors.grey[300]!;
              }
            } else {
              color = Colors.grey[300]!;
            }
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                height: 8.0,
                color: color,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HeaderWidget(),
      ),
      body: currentFlashcard == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProgressIndicator(),
                  const SizedBox(height: 10.0),
                  Text(
                    'Flashcard ${currentIndex + 1} of ${remainingFlashcards.length}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 50.0),
                  Container(
                    height: 350.0,
                    width: 900,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isFront ? currentFlashcard!.term : currentFlashcard!.definition,
                        style: const TextStyle(fontSize: 28.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  CustomButton(
                    onPressed: _toggleCard,
                    text: 'Flip',
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        onPressed: () => _markAsKnown(false),
                        text: 'I don\'t know',
                        color: Colors.red,
                        hoverColor: Colors.red[700]!,
                      ),
                      CustomButton(
                        onPressed: () => _markAsKnown(true),
                        text: 'I know',
                        color: Colors.green,
                        hoverColor: Colors.green[700]!
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}