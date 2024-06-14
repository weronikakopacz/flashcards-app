import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 210, 179, 211),
      title: const Text(
        'Fishcard App',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        const SizedBox(width: 16),
        const Text(
        'Fishcard App',
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
        TextButton(
          onPressed: () {
            authBloc.add(const LogoutEvent());
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text(
            'Logout',
            style: TextStyle(color: Color.fromARGB(255, 22, 22, 22)),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}