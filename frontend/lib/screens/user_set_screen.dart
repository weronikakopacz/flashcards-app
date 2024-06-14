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
        final List<Set> sets = await SetService().getUserSets(accessToken);
        if (mounted) {
          setState(() {
            userSets = sets;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: HeaderWidget(),
          ),
          body: errorMessage != null
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