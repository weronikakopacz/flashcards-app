import 'dart:convert';
import 'package:frontend/models/statistic_data.dart';
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
}