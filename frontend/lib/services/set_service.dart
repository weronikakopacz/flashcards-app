import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/set.dart';
import 'package:logger/logger.dart';

class SetService {
  final Logger _logger = Logger();

  Future<Map<String, dynamic>> getPublicSets({int currentPage = 1, String? searchQuery}) async {
    try {
      final queryParameters = {
        'currentPage': currentPage.toString(),
        if (searchQuery != null) 'searchQuery': searchQuery,
      };
      final uri = Uri.http('localhost:8080', '/api/sets/getPublicSets', queryParameters);
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> setsJson = data['sets'];
        final int totalPages = data['totalPages'];
        final sets = setsJson.map((setJson) => Set.fromJson(setJson)).toList();
        return {'sets': sets, 'totalPages': totalPages};
      } else {
        throw Exception('Failed to load public sets');
      }
    } catch (error) {
      _logger.e('Error getting public sets: $error');
      throw Exception('Error getting public sets: $error');
    }
  }

  Future<Map<String, dynamic>> getUserSets({required String accessToken, int currentPage = 1, String? searchQuery}) async {
    try {
      final queryParameters = {
        'currentPage': currentPage.toString(),
        if (searchQuery != null) 'searchQuery': searchQuery,
      };
      final uri = Uri.http('localhost:8080', '/api/sets/getUserSets', queryParameters);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> userSetsJson = data['sets'];

        final List<Set> userSets = userSetsJson.map((setJson) {
          return Set.fromJson(setJson);
        }).toList();
        final int totalPages = data['totalPages'];

        return {'sets': userSets, 'totalPages': totalPages};
      } else {
        throw Exception('Failed to load user sets');
      }
    } catch (error) {
      _logger.e('Error getting user sets: $error');
      throw Exception('Error getting user sets: $error');
    }
  }

  Future<String> addSet(Set newSet, String accessToken) async {
    try {
      final url = Uri.parse('http://localhost:8080/api/sets/add');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode(newSet.toJson());
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        _logger.i('Set added successfully');
        return responseBody['id'];
      } else {
        throw Exception('Failed to add set: ${response.statusCode}');
      }
    } catch (error) {
      _logger.e('Error adding set: $error');
      throw Exception('Error adding set: $error');
    }
  }

  Future<Set> getSet(String setId) async {
  try {
    final url = Uri.parse('http://localhost:8080/api/sets/getSet/$setId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> setJson = jsonResponse['set'];
      return Set.fromJson(setJson);
    } else {
      throw Exception('Failed to load set: ${response.statusCode}');
    }
  } catch (error) {
    _logger.e('Error fetching set: $error');
    throw Exception('Error fetching set: $error');
  }
  }
}