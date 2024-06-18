import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/statistic_service.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  HeaderWidgetState createState() => HeaderWidgetState();
}

class HeaderWidgetState extends State<HeaderWidget> {
  String? userEmail;
  UserStats? userStats;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        final email = await AuthService().getUserEmail(accessToken);
        setState(() {
          userEmail = email;
        });
      }
    } catch (error) {
      throw 'User not authenticated';
    }
  }

  Future<UserStats?> fetchUserStats() async {
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context);
      final state = authBloc.state;
      if (state is AuthLoggedIn) {
        final accessToken = state.accessToken;
        final stats = await StatisticService().fetchUserStatistics(accessToken);
        setState(() {
          userStats = stats;
        });
        return stats;
      }
      throw 'User not authenticated';
    } catch (error) {
      throw 'User not authenticated';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 210, 179, 211),
      title: const Text(
        'Flashcard App',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        const SizedBox(width: 16),
        const Text(
          'Flashcard App',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.home, color: Color.fromARGB(255, 22, 22, 22)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        IconButton(
          icon: const Icon(Icons.collections, color: Color.fromARGB(255, 22, 22, 22)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/user-sets');
          },
        ),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: Color.fromARGB(255, 22, 22, 22)),
          onSelected: (value) async {
            if (value == 'logout') {
              authBloc.add(const LogoutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            } else if (value == 'user_stats') {
              final userStats = await fetchUserStats();
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/user-stats', arguments: userStats);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            if (userEmail != null)
              PopupMenuItem<String>(
                value: 'email',
                child: Text(userEmail!),
              ),
            const PopupMenuItem<String>(
              value: 'user_stats',
              child: Text('User Statistics'),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}