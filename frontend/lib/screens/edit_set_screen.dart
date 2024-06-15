import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/set_service.dart';
import 'package:frontend/auth/auth_bloc.dart';

class EditSetScreen extends StatefulWidget {
  final String setId;

  const EditSetScreen({super.key, required this.setId});

  @override
  EditSetScreenState createState() => EditSetScreenState();
}

class EditSetScreenState extends State<EditSetScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isPublic = false;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSetDetails();
  }

  Future<void> _loadSetDetails() async {
    try {
        final set = await SetService().getSet(widget.setId);
        setState(() {
          _titleController.text = set.title;
          _isPublic = set.isPublic;
          _isLoading = false;
        });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSet(AuthBloc authBloc) async {
    try {
      final updatedSet = Set(
        id: widget.setId,
        title: _titleController.text,
        isPublic: _isPublic,
      );

      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        await SetService().editSet(widget.setId, updatedSet, accessToken);
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/set-detail', arguments: widget.setId);
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
            title: const Text('Edit Set'),
            automaticallyImplyLeading: false,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
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
                      ElevatedButton(
                        onPressed: () => _updateSet(BlocProvider.of<AuthBloc>(context)),
                        child: const Text('Update Set'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _cancel,
                        child: const Text('Cancel'),
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