import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:frontend/models/flashcard.dart';

class FlashcardService {
  static const String baseUrl = 'http://localhost:8080';
  final Logger _logger = Logger();

  Future<void> addFlashcard(String setId, Flashcard newFlashcard, String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/flashcards/add/$setId');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode(newFlashcard.toJson());
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