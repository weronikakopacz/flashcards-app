import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthService {
  final Logger _logger = Logger();

  Future<void> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        _logger.i('User registered successfully');
      } else {
        _logger.e('Error during registration: ${response.body}');
        throw Exception('Registration failed');
      }
    } catch (error) {
      _logger.e('Error during registration: $error');
      throw Exception('Registration failed');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        _logger.i('Login successful');
      } else {
        _logger.e('Error during login: ${response.body}');
        throw Exception('Login failed');
      }
    } catch (error) {
      _logger.e('Error during login: $error');
      throw Exception('Login failed');
    }
  }
}