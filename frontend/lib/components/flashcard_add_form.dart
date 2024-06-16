import 'package:flutter/material.dart';

class FlashcardAddForm extends StatelessWidget {
  final TextEditingController termController;
  final TextEditingController definitionController;
  final VoidCallback onAddPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onFlashcardAdded;

  const FlashcardAddForm({
    super.key,
    required this.termController,
    required this.definitionController,
    required this.onAddPressed,
    required this.onCancelPressed,
    required this.onFlashcardAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: termController,
          decoration: const InputDecoration(labelText: 'Term'),
        ),
        TextField(
          controller: definitionController,
          decoration: const InputDecoration(labelText: 'Definition'),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                onAddPressed();
                onFlashcardAdded();
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: onCancelPressed,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}