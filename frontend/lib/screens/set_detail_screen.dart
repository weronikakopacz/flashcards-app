import 'package:flutter/material.dart';
import 'package:frontend/components/header_widget.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/set_service.dart';

class SetDetailScreen extends StatefulWidget {
  final String setId;

  const SetDetailScreen({super.key, required this.setId});

  @override
  SetDetailScreenState createState() => SetDetailScreenState();
}

class SetDetailScreenState extends State<SetDetailScreen> {
  late Future<Set> setFuture;

  @override
  void initState() {
    super.initState();
    setFuture = SetService().getSet(widget.setId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: HeaderWidget()),
      body: FutureBuilder<Set>(
        future: setFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final set = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${set.title}', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Set not found'));
          }
        },
      ),
    );
  }
}
