import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/set_service.dart';
import 'package:frontend/auth/auth_bloc.dart';

class CreateSetScreen extends StatefulWidget {
  const CreateSetScreen({super.key});

  @override
  CreateSetScreenState createState() => CreateSetScreenState();
}

class CreateSetScreenState extends State<CreateSetScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isPublic = false;
  String? _errorMessage;

  Future<void> _createSet(AuthBloc authBloc) async {
    try {
      final newSet = Set(
        title: _titleController.text,
        isPublic: _isPublic,
      );

      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        final setId = await SetService().addSet(newSet, accessToken);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/set-detail', arguments: setId);
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create New Set'),
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Checkbox(
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value!;
                        });
                      },
                    ),
                    const Text('Public'),
                  ],
                ),
                CustomButton(
                  onPressed: () => _createSet(BlocProvider.of<AuthBloc>(context)),
                  text: 'Create Set',
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  onPressed: _cancel,
                  text: 'Cancel',
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}