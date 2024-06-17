import 'package:flutter/material.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/components/header_widget.dart';
import '../models/flashcard.dart';

class SummaryScreen extends StatelessWidget {
  final List<Flashcard> flashcards;
  final int knownCount;
  final int unknownCount;
  final VoidCallback onRepeatUnknown;
  final VoidCallback onRepeatAll;
  final VoidCallback onFinish;
  final List<bool?> flashcardStatus;

  const SummaryScreen({
    required this.flashcards,
    required this.knownCount,
    required this.unknownCount,
    required this.onRepeatUnknown,
    required this.onRepeatAll,
    required this.onFinish,
    required this.flashcardStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HeaderWidget(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text('Known Count: $knownCount', style: const TextStyle(color: Colors.green, fontSize: 20)),
            Text('Unknown Count: $unknownCount', style: const TextStyle(color: Colors.red, fontSize: 20)),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Repeat All',
              onPressed: onRepeatAll,
              width: 150,
            ),
            if (unknownCount > 0) ...[
              const SizedBox(height: 20),
              CustomButton(
                onPressed: onRepeatUnknown,
                text: 'Repeat Unknown',
                width: 150,
              ),
            ],
            const SizedBox(height: 20),
            CustomButton(
              onPressed: onFinish,
              text: 'Finish',
              width: 150,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  Flashcard flashcard = flashcards[index];
                  bool? isCorrect = flashcardStatus[index];

                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Term: ${flashcard.term}',
                          style: TextStyle(
                          color: isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : Colors.black,
                        )),
                        Text(
                          'Definition: ${flashcard.definition}',
                          style: TextStyle(
                            color: isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}