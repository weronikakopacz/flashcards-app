import 'dart:convert';
import 'package:frontend/models/statistic_data.dart';
import 'package:frontend/models/user_stats.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class StatisticService {
  final Logger _logger = Logger();

  Future<void> addStatistic(StatisticData newStatistic, String accessToken) async {
    try {
      final url = Uri.parse('http://localhost:8080/api/statistics/add');
      final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        };
        final body = jsonEncode(newStatistic.toJson());
        final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
          _logger.i('Statistic added successfully');
        } else {
          throw Exception('Failed to add statistic: ${response.statusCode}');
        }
    } catch (error) {
      _logger.e('Error adding statistic: $error');
      throw Exception('Error adding statistic: $error');
    }
  }

  Future<UserStats?> fetchUserStatistics(String accessToken) async {
    final url = Uri.parse('http://localhost:8080/api/statistics/user');
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return UserStats.fromJson(jsonDecode(response.body));
      } else {
        _logger.e('Failed to load user statistics: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.e('Error fetching user statistics: $e');
      return null;
    }
  }
}