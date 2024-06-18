import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/set_stats.dart';
import 'package:frontend/models/study_arguments.dart';
import 'package:frontend/models/summary_arguments.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:frontend/screens/create_set_screen.dart';
import 'package:frontend/screens/edit_set_screen.dart';
import 'package:frontend/screens/flashcard_study_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/registration_screen.dart';
import 'package:frontend/screens/set_detail_screen.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/screens/set_statistics_sreen.dart';
import 'package:frontend/screens/summary_screen.dart';
import 'package:frontend/screens/user_set_screen.dart';
import 'package:frontend/screens/user_statistics_screen.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late AuthBloc _authBloc;
  String _initialRoute = '/login';

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(AuthService(), prefs: widget.prefs)..add(const CheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            setState(() {
              _initialRoute = '/home';
            });
          } else {
            setState(() {
              _initialRoute = '/login';
            });
          }
        },
        child: MaterialApp(
          title: 'My App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: _initialRoute,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/registration': (context) => const RegistrationScreen(),
            '/home': (context) => const HomeScreen(),
            '/new-set': (context) => const CreateSetScreen(),
            '/user-sets': (context) => const UserSetScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/summary') {
              final arguments = settings.arguments;
              if (arguments is SummaryArguments) {
                return MaterialPageRoute(
                  builder: (context) => SummaryScreen(
                    knownCount: arguments.knownCount,
                    unknownCount: arguments.unknownCount,
                    onRepeatUnknown: arguments.onRepeatUnknown,
                    onRepeatAll: arguments.onRepeatAll,
                    onFinish: arguments.onFinish,
                    flashcards: arguments.flashcards,
                    flashcardStatus: arguments.flashcardStatus,
                    setId: arguments.setId,
                    repeatUnknown: arguments.repeatUnknown,
                  ),
                );
              } else {
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );}
            } else if (settings.name == '/set-detail') {
              final setId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => SetDetailScreen(setId: setId),
              );
            } else if (settings.name == '/edit-set') {
              final setId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => EditSetScreen(setId: setId),
              );
            } else if (settings.name == '/study') {
              final arguments = settings.arguments;
              if (arguments is StudyArguments) {
                return MaterialPageRoute(
                  builder: (context) => FlashcardStudyScreen(
                    flashcards: arguments.flashcards,
                    setId: arguments.setId, 
                    repeatUnknown: arguments.repeatUnknown),
                );}
              else {
                  return MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  );
                }
            } else if (settings.name == '/user-stats') {
                final arguments = settings.arguments; 
                if (arguments is UserStats) {
                  return MaterialPageRoute(
                    builder: (context) => UserStatisticsScreen(userStats: arguments),
                  );
              } else {
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );
              }
            } else if (settings.name == '/set-statistics') {
              final arguments = settings.arguments;
              if (arguments is SetStats) {
                return MaterialPageRoute(
                  builder: (context) => SetStatisticsScreen(setStats: arguments),
                );
              }
            } else {
              return MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}