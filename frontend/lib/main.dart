import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/create_set_screen.dart';
import 'package:frontend/screens/edit_set_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/registration_screen.dart';
import 'package:frontend/screens/set_detail_screen.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/screens/user_set_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService(), prefs: prefs)..add(const CheckLoginEvent()),
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/registration': (context) => const RegistrationScreen(),
          '/home': (context) => const HomeScreen(),
          '/new-set': (context) => const CreateSetScreen(),
          '/user-sets': (context) => const UserSetScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/set-detail') {
            final setId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => SetDetailScreen(setId: setId),
            );
          } else if (settings.name == '/edit-set') {
            final setId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => EditSetScreen(setId: setId),
            );
          }
          return null;
        },
      ),
    );
  }
}