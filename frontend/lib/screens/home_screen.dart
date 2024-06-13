import 'package:flutter/material.dart';
import 'package:frontend/components/header_widget.dart';
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
    if (mounted) {
      setState(() {
        publicSets = sets;
      });
    }
  } catch (error) {
    setState(() {
      errorMessage = error.toString();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: HeaderWidget()),
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
                  subtitle: Text(set.creatorEmail?.email ?? 'Unknown'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 179, 211),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/new-set');
          if (result == true) {
            _loadPublicSets();
          }
        },
        tooltip: 'Create new set',
        child: const Icon(Icons.add),
      ),
    );
  }
}