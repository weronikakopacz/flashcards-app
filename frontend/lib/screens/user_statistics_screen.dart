import 'package:flutter/material.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/user_stats.dart';

class UserStatisticsScreen extends StatelessWidget {
  const UserStatisticsScreen({super.key, required this.userStats});
  final UserStats userStats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), 
        child: HeaderWidget(),
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
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text(
                    'Total Sets Completed',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${userStats.totalSetsCompleted}',
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
                    userStats.averageAccuracy.toStringAsFixed(2),
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
                    'Average Repeat Unknown',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    userStats.averageRepeatUnknown.toStringAsFixed(2),
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
