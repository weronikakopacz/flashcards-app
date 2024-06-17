import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/auth_bloc.dart';
import 'package:frontend/components/custom_button.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/statistic_data.dart';
import 'package:frontend/services/statistic_service.dart';
import '../models/flashcard.dart';

class SummaryScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  final int knownCount;
  final int unknownCount;
  final VoidCallback onRepeatUnknown;
  final VoidCallback onRepeatAll;
  final VoidCallback onFinish;
  final List<bool?> flashcardStatus;
  final String setId;
  final bool repeatUnknown;

  const SummaryScreen({
    required this.flashcards,
    required this.knownCount,
    required this.unknownCount,
    required this.onRepeatUnknown,
    required this.onRepeatAll,
    required this.onFinish,
    required this.flashcardStatus,
    required this.setId,
    required this.repeatUnknown,
    super.key,
  });

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  late List<Flashcard> flashcards;
  late int knownCount;
  late int unknownCount;
  late VoidCallback onRepeatUnknown;
  late VoidCallback onRepeatAll;
  late VoidCallback onFinish;
  late List<bool?> flashcardStatus;
  late String setId;
  late bool repeatUnknown;

  @override
  void initState() {
    super.initState();
    flashcards = widget.flashcards;
    knownCount = widget.knownCount;
    unknownCount = widget.unknownCount;
    onRepeatUnknown = widget.onRepeatUnknown;
    onRepeatAll = widget.onRepeatAll;
    onFinish = widget.onFinish;
    flashcardStatus = widget.flashcardStatus;
    setId = widget.setId;
    repeatUnknown = widget.repeatUnknown;
    addStatistics(
      BlocProvider.of<AuthBloc>(context),
    );
  }

  Future<void> addStatistics(AuthBloc authBloc) async {
    final newStatistic = StatisticData(
      setId: setId,
      correct: knownCount,
      incorrect: unknownCount,
      repeatUnknown: repeatUnknown ? 1 : 0,
    );

    final state = authBloc.state;
    if (state is AuthLoggedIn) {
      final accessToken = state.accessToken;
      await StatisticService().addStatistic(newStatistic, accessToken);
    } else {
      throw 'User not authenticated';
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Text('Known Count: $knownCount', style: const TextStyle(color: Colors.green, fontSize: 20)),
                Text('Unknown Count: $unknownCount', style: const TextStyle(color: Colors.red, fontSize: 20)),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Repeat All',
                  onPressed: onRepeatAll,
                  width: 150,
                ),
                if (unknownCount > 0) ...[
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: onRepeatUnknown,
                    text: 'Repeat Unknown',
                    width: 150,
                  ),
                ],
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: onFinish,
                  text: 'Finish',
                  width: 150,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: flashcards.length,
                    itemBuilder: (context, index) {
                      Flashcard flashcard = flashcards[index];
                      bool? isCorrect = flashcardStatus[index];

                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Term: ${flashcard.term}',
                              style: TextStyle(
                              color: isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : Colors.black,
                            )),
                            Text(
                              'Definition: ${flashcard.definition}',
                              style: TextStyle(
                                color: isCorrect == true ? Colors.green : isCorrect == false ? Colors.red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}