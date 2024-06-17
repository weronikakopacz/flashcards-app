import 'package:flutter/material.dart';

import '../models/flashcard.dart';

class SummaryScreen extends StatelessWidget {
  final List<Flashcard> flashcards;
  final int knownCount;
  final int unknownCount;
  final VoidCallback onRepeatUnknown;
  final VoidCallback onRepeatAll;
  final VoidCallback onFinish;

  const SummaryScreen({
    required this.flashcards,
    required this.knownCount,
    required this.unknownCount,
    required this.onRepeatUnknown,
    required this.onRepeatAll,
    required this.onFinish,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Known Count: $knownCount'),
            Text('Unknown Count: $unknownCount'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRepeatUnknown,
              child: const Text('Repeat Unknown'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRepeatAll,
              child: const Text('Repeat All'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onFinish,
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}