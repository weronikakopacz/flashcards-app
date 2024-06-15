import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/set_service.dart';
import 'package:frontend/auth/auth_bloc.dart';

class SetDetailScreen extends StatefulWidget {
  final String setId;

  const SetDetailScreen({super.key, required this.setId});

  @override
  SetDetailScreenState createState() => SetDetailScreenState();
}

class SetDetailScreenState extends State<SetDetailScreen> {
  late Future<Set> setFuture;
  String? loggedInUserId;
  bool isLoading = true;

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
        setState(() {
          loggedInUserId = userId;
        });
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      setState(() {
        throw 'User not authenticated';
      });
    }
  }

  Future<Set> _loadSetDetails() async {
    try {
      final set = await SetService().getSet(widget.setId);
      return set;
    } catch (error) {
      throw 'Failed to load set details: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: HeaderWidget()),
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Title: ${set.title}', style: Theme.of(context).textTheme.titleLarge),
                      if (set.creatorUserId == loggedInUserId)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editSet(context),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteSet(context),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Set not found'));
          }
        },
      ),
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

      if (set.creatorUserId == loggedInUserId) {
        await SetService().deleteSet(widget.setId, accessToken!);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        throw 'User does not have permission to delete this set';
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete set: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}