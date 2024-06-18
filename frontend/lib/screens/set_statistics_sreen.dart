import 'package:flutter/material.dart';
import 'package:frontend/models/set_stats.dart';

class SetStatisticsScreen extends StatelessWidget {
  final SetStats setStats;

  const SetStatisticsScreen({super.key, required this.setStats});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.star_border, color: Colors.yellow),
                  title: const Text(
                    'Total Attempts',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${setStats.totalAttempts}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text(
                    'Total Correct',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${setStats.totalCorrect}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.red),
                  title: const Text(
                    'Total Incorrect',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${setStats.totalIncorrect}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.repeat, color: Colors.orange),
                  title: const Text(
                    'Total Repeat Unknown',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${setStats.totalRepeatUnknown}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: const Icon(Icons.assessment, color: Colors.blue),
                  title: const Text(
                    'Average Accuracy',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    setStats.averageAccuracy.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}