import 'package:flutter/material.dart';
import 'package:frontend/models/flashcard.dart';
import 'package:frontend/services/flashcard_service.dart';
import 'package:logger/logger.dart';

class FlashcardListWidget extends StatefulWidget {
  final String setId;
  final VoidCallback refreshCallback;

  const FlashcardListWidget({
    super.key,
    required this.setId,
    required this.refreshCallback,
  });

  @override
  FlashcardListWidgetState createState() => FlashcardListWidgetState();

  void refreshFlashcards() {}
}

class FlashcardListWidgetState extends State<FlashcardListWidget> {
  late Future<List<Flashcard>> _flashcardsFuture;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _fetchFlashcards();
  }

  Future<List<Flashcard>> _fetchFlashcards() async {
    try {
      return await FlashcardService().getFlashcards(widget.setId);
    } catch (error) {
      _logger.e('Error fetching flashcards: $error');
      throw Exception('Error fetching flashcards: $error');
    }
  }

  void refreshFlashcards() {
    setState(() {
      _flashcardsFuture = _fetchFlashcards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Flashcard>>(
      future: _flashcardsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final flashcards = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = flashcards[index];
              return ListTile(
                title: Text(flashcard.term),
                subtitle: Text(flashcard.definition),
              );
            },
          );
        } else {
          return const Center(child: Text('No flashcards found'));
        }
      },
    );
  }
}