import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  void _registerUser(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    context.read<AuthBloc>().add(RegisterEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthRegistered) {
                Navigator.pushReplacementNamed(context, '/login');
              } else if (state is AuthError) {
                setState(() {
                  errorMessage = state.errorMessage;
                });
              }
            },
            builder: (context, state) {
              if (state is AuthStateLoading) {
                return const CircularProgressIndicator();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _registerUser(context),
                    child: const Text('Register'),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 16.0),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}