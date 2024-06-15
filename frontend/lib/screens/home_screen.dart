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
  int currentPage = 1;
  int totalPages = 1;
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    publicSets = [];
    _loadPublicSets();
  }

  Future<void> _loadPublicSets() async {
    try {
      final result = await SetService().getPublicSets(currentPage: currentPage, searchQuery: searchQuery);
      if (mounted) {
        setState(() {
          publicSets = result['sets'];
          totalPages = result['totalPages'];
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
    });
    _loadPublicSets();
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    _loadPublicSets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: HeaderWidget()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: errorMessage != null
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
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/set-detail',
                            arguments: set.id,
                          );
                        },
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 1 ? () => _onPageChanged(currentPage - 1) : null,
              ),
              Text('Page $currentPage of $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages ? () => _onPageChanged(currentPage + 1) : null,
              ),
            ],
          ),
        ],
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