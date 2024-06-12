import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/set.dart';
import 'package:logger/logger.dart';

class SetService {
  final Logger _logger = Logger();

  Future<List<Set>> getPublicSets() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/sets/getPublicSets'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> setsJson = data['sets']['publicsets'];
        return setsJson.map((setJson) => Set.fromJson(setJson)).toList();
      } else {
        throw Exception('Failed to load public sets');
      }
    } catch (error) {
      _logger.e('Error getting public sets: $error');
      throw Exception('Error getting public sets: $error');
    }
  }

  Future<void> addSet(Set newSet, String accessToken) async {
    try {
      final url = Uri.parse('http://localhost:8080/api/sets/add');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode(newSet.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        _logger.i('Set added successfully');
      } else {
        throw Exception('Failed to add set: ${response.statusCode}');
      }
    } catch (error) {
      _logger.e('Error adding set: $error');
      throw Exception('Error adding set: $error');
    }
  }
}