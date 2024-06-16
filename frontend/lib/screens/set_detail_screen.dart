import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/components/flashcard_add_form.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/models/flashcard.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/flashcard_service.dart';
import 'package:frontend/services/set_service.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:logger/logger.dart';

class SetDetailScreen extends StatefulWidget {
  final String setId;

  const SetDetailScreen({super.key, required this.setId});

  @override
  SetDetailScreenState createState() => SetDetailScreenState();
}

class SetDetailScreenState extends State<SetDetailScreen> {
  late Future<Set> setFuture;
  String? loggedInUserId;
  bool isAddingFlashcard = false;
  final _termController = TextEditingController();
  final _definitionController = TextEditingController();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    setFuture = _loadSetDetails();
    _fetchLoggedInUserId();
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
      _handleError('Failed to fetch user ID: $error');
    }
  }

  void _updateLoggedInUserId(String? userId) {
    setState(() {
      loggedInUserId = userId;
    });
  }

  Future<Set> _loadSetDetails() async {
    try {
      final set = await SetService().getSet(widget.setId);
      _logger.i('Set details loaded for set ID: ${widget.setId}');
      return set;
    } catch (error) {
      _handleError('Failed to load set details: $error');
      rethrow;
    }
  }

  Future<void> _addFlashcard() async {
    try {
      final term = _termController.text;
      final definition = _definitionController.text;

      if (term.isEmpty || definition.isEmpty) {
        _showSnackBar('Both term and definition are required');
        return;
      }

      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        await _saveFlashcard(term, definition, accessToken);
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      _handleError('Failed to add flashcard: $error');
    }
  }

  Future<void> _saveFlashcard(String term, String definition, String accessToken) async {
    final newFlashcard = Flashcard(
      term: term,
      definition: definition,
    );

    await FlashcardService().addFlashcard(widget.setId, newFlashcard, accessToken);
    _logger.i('Flashcard added: Term: $term, Definition: $definition');

    _clearControllers();
    _toggleAddingFlashcard(false);
    _showSnackBar('Flashcard added successfully');
  }

  void _clearControllers() {
    _termController.clear();
    _definitionController.clear();
  }

  void _toggleAddingFlashcard(bool adding) {
    setState(() {
      isAddingFlashcard = adding;
    });
  }

  void _handleError(String error) {
    _logger.e(error);
    _showSnackBar('Error: $error');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: HeaderWidget(),
      ),
      body: FutureBuilder<Set>(
        future: setFuture,
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
            final set = snapshot.data!;
            return _buildSetDetails(set);
          } else {
            return const Center(child: Text('Set not found'));
          }
        },
      ),
    );
  }

  Widget _buildSetDetails(Set set) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Title: ${set.title}', style: Theme.of(context).textTheme.titleLarge),
              if (_isUserAllowedToEdit(set))
                _buildActionButtons(),
            ],
          ),
          const SizedBox(height: 16.0),
          if (isAddingFlashcard)
            FlashcardAddForm(
              termController: _termController,
              definitionController: _definitionController,
              onAddPressed: _addFlashcard,
              onCancelPressed: () => _toggleAddingFlashcard(false),
            ),
        ],
      ),
    );
  }

  bool _isUserAllowedToEdit(Set set) {
    return set.creatorUserId == loggedInUserId;
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _toggleAddingFlashcard(true),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editSet(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSet(context),
        ),
      ],
    );
  }

  void _editSet(BuildContext context) {
    Navigator.pushNamed(context, '/edit-set', arguments: widget.setId);
  }

  void _deleteSet(BuildContext context) async {
    try {
      final set = await setFuture;
      final authService = AuthService();
      final accessToken = authService.getAccessToken();

      if (_isUserAllowedToEdit(set)) {
        await SetService().deleteSet(widget.setId, accessToken!);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        throw 'User does not have permission to delete this set';
      }
    } catch (error) {
      _handleError('Failed to delete set: $error');
    }
  }
}