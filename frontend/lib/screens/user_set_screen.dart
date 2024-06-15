import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/set_service.dart';

class UserSetScreen extends StatefulWidget {
  const UserSetScreen({super.key});

  @override
  UserSetScreenState createState() => UserSetScreenState();
}

class UserSetScreenState extends State<UserSetScreen> {
  late List<Set> userSets;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    userSets = [];
    _loadUserSets();
  }

  Future<void> _loadUserSets() async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        final result = await SetService().getUserSets(
          accessToken: accessToken,
          currentPage: currentPage,
          searchQuery: searchQuery,
        );
        if (mounted) {
          setState(() {
            userSets = result['sets'];
            totalPages = result['totalPages'];
          });
        }
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
    });
    _loadUserSets();
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    _loadUserSets();
  }

  Future<void> _deleteSet(String setId) async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        await SetService().deleteSet(setId, accessToken);
        _loadUserSets();
      } else {
        throw 'User not authenticated';
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  Future<void> _editSet(String setId) async {
    final result = await Navigator.pushNamed(context, '/edit-set', arguments: setId);
    if (result == true) {
      _loadUserSets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: HeaderWidget(),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Expanded(
                child: errorMessage != null
                    ? Center(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : ListView.builder(
                        itemCount: userSets.length,
                        itemBuilder: (context, index) {
                          final set = userSets[index];
                          return ListTile(
                            title: Text(set.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editSet(set.id!),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteSet(set.id!),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await Navigator.pushNamed(
                                context,
                                '/set-detail',
                                arguments: set.id,
                              );
                            },
                          );
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 1 ? () => _onPageChanged(currentPage - 1) : null,
                  ),
                  Text('Page $currentPage of $totalPages'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages ? () => _onPageChanged(currentPage + 1) : null,
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 210, 179, 211),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/new-set');
              if (result == true) {
                _loadUserSets();
              }
            },
            tooltip: 'Create new set',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}