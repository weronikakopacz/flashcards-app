import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/models/flashcard.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/screens/flashcard_edit_screen.dart';
import 'package:frontend/screens/flashcard_study_screen.dart';
import 'package:frontend/services/flashcard_service.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:logger/logger.dart';

class FlashcardListWidget extends StatefulWidget {
  final String setId;
  final Set set;
  final VoidCallback refreshCallback;

  const FlashcardListWidget({
    super.key,
    required this.setId,
    required this.set,
    required this.refreshCallback,
  });

  @override
  FlashcardListWidgetState createState() => FlashcardListWidgetState();

  void refreshFlashcards() {}
}

class FlashcardListWidgetState extends State<FlashcardListWidget> {
  late Future<List<Flashcard>> _flashcardsFuture;
  final Logger _logger = Logger();
  String? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _flashcardsFuture = _fetchFlashcards();
    _fetchLoggedInUserId();
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
          return Column(
            children: [
              if (flashcards.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashcardStudyScreen(flashcards: flashcards),
                        ),
                      );
                    },
                    child: const Text('Start Studying'),
                  ),
                ),
                const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: flashcards.length,
                  itemBuilder: (context, index) {
                    final flashcard = flashcards[index];
                    return ListTile(
                      title: Text(flashcard.term),
                      subtitle: Text(flashcard.definition),
                      trailing: _buildActionIcons(flashcard),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No flashcards found'));
        }
      },
    );
  }

  Future<void> _fetchLoggedInUserId() async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        final userId = await AuthService().fetchUserId(accessToken);
        _updateLoggedInUserId(userId);
        _logger.i('User ID fetched: $userId');
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      throw Exception('Error fetching user ID: $error');
    }
  }

  void _updateLoggedInUserId(String? userId) {
    setState(() {
      loggedInUserId = userId;
    });
  }

  Widget _buildActionIcons(Flashcard flashcard) {
    if (loggedInUserId == widget.set.creatorUserId) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editFlashcard(flashcard),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteFlashcard(flashcard.id ?? ''),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _editFlashcard(Flashcard flashcard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardEditScreen(
          flashcard: flashcard,
        ),
      ),
    ).then((result) {
      if (result != null && result as bool) {
        refreshFlashcards();
      }
    });
  }

  void _deleteFlashcard(String flashcardId) async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        await FlashcardService().deleteFlashcard(flashcardId, accessToken);
        _logger.i('Flashcard deleted: $flashcardId');
        refreshFlashcards();
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      _logger.e('Error deleting flashcard: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete flashcard')),
      );
    }
  }
}