import 'package:flutter/material.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/flashcard.dart';

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
    flashcardStatus = List.filled(widget.flashcards.length, null);
    _initializeFlashcards();
  }

  void _initializeFlashcards() {
    setState(() {
      allFlashcards = List.from(widget.flashcards);
      remainingFlashcards = List.from(widget.flashcards);
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
      final originalIndex = widget.flashcards.indexOf(currentFlashcard!);
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
    final unknownCount = flashcardStatus.length - knownCount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Summary'),
        content: Text('You know $knownCount cards.\nYou don\'t know $unknownCount cards.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartLearning(onlyUnknown: true);
            },
            child: const Text('Repeat Unknown'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartLearning(onlyUnknown: false);
            },
            child: const Text('Repeat All'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _restartLearning({required bool onlyUnknown}) {
    setState(() {
      if (onlyUnknown) {
        remainingFlashcards = allFlashcards.where((flashcard) {
          final index = allFlashcards.indexOf(flashcard);
          return flashcardStatus[index] == false;
        }).toList();
      } else {
        remainingFlashcards = List.from(allFlashcards);
      }
      remainingFlashcards.shuffle();
      flashcardStatus = List.filled(remainingFlashcards.length, null);
      currentIndex = 0;
      _pickRandomFlashcard();
    });
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
              final originalIndex = widget.flashcards.indexOf(remainingFlashcards[index]);
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
                  ElevatedButton(
                    onPressed: _toggleCard,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Flip',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _markAsKnown(false),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'I don\'t know',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _markAsKnown(true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'I know',
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}