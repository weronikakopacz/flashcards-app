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

  Future<List<Flashcard>> getFlashcards(String setId) async {
    try {
      final url = Uri.parse('$baseUrl/api/flashcards/getFlashcards/$setId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> flashcardsJson = jsonDecode(response.body)['flashcards'];
        final flashcards = flashcardsJson.map((json) => Flashcard.fromJson(json)).toList();
        _logger.i('Flashcards fetched successfully for set ID: $setId');
        return flashcards;
      } else {
        throw Exception('Failed to fetch flashcards: ${response.statusCode}');
      }
    } catch (error) {
      _logger.e('Error fetching flashcards: $error');
      throw Exception('Error fetching flashcards: $error');
    }
  }

  Future<void> editFlashcard(String flashcardId, Map<String, dynamic> updatedFields, String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/flashcards/edit/$flashcardId');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode(updatedFields);
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 204) {
        _logger.i('Flashcard edited successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Flashcard not found');
      } else if (response.statusCode == 400) {
        throw Exception('Validation error: ${response.body}');
      } else if (response.statusCode == 403) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to edit flashcard: ${response.statusCode}');
      }
    } catch (error) {
      _logger.e('Error editing flashcard: $error');
      throw Exception('Error editing flashcard: $error');
    }
  }

  Future<void> deleteFlashcard(String flashcardId, String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/flashcards/delete/$flashcardId');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        _logger.i('Flashcard deleted successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Flashcard not found');
      } else if (response.statusCode == 403) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to delete flashcard: ${response.statusCode}');
      }
    } catch (error) {
      _logger.e('Error deleting flashcard: $error');
      throw Exception('Error deleting flashcard: $error');
    }
  }
}