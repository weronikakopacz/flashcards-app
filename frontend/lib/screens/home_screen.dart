import 'package:flutter/material.dart';
import 'package:frontend/models/set.dart';
import 'package:frontend/services/set_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late List<Set> publicSets;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    publicSets = [];
    _loadPublicSets();
  }

  Future<void> _loadPublicSets() async {
    try {
      final List<Set> sets = await SetService().getPublicSets();
      setState(() {
        publicSets = sets;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: errorMessage != null
        ? Center(
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        : ListView.builder(
            itemCount: publicSets.length,
            itemBuilder: (context, index) {
              final set = publicSets[index];
              return ListTile(
                title: Text(set.title),
                subtitle: Text(set.creatorUserId ?? ''),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/new-set');
          if (result == true) {
            // Refresh the list if a new set was created
            _loadPublicSets();
          }
        },
        tooltip: 'Create new set',
        child: const Icon(Icons.add),
      ),
    );
  }
}
