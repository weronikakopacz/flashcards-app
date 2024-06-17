import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/models/flashcard.dart';
import 'package:frontend/services/flashcard_service.dart';
import 'package:logger/logger.dart';

class FlashcardEditScreen extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardEditScreen({super.key, required this.flashcard});

  @override
  FlashcardEditScreenState createState() => FlashcardEditScreenState();
}

class FlashcardEditScreenState extends State<FlashcardEditScreen> {
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _termController.text = widget.flashcard.term;
    _definitionController.text = widget.flashcard.definition;
  }

  Future<void> _saveChanges() async {
    try {
      final String term = _termController.text;
      final String definition = _definitionController.text;
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        await FlashcardService().editFlashcard(widget.flashcard.id!, accessToken, {
          'term': term,
          'definition': definition,
        });
        _logger.i('Flashcard edited: ID ${widget.flashcard.id}, Term: $term, Definition: $definition');
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);}
      else {
        throw 'User not authenticated';
      }
    } catch (error) {
      _logger.e('Failed to save changes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _termController,
              decoration: const InputDecoration(
                labelText: 'Term',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _definitionController,
              decoration: const InputDecoration(
                labelText: 'Definition',
              ),
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              onPressed: _saveChanges,
              text: 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }
}