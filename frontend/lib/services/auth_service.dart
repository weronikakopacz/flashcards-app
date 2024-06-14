import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthService {
  final Logger _logger = Logger();
  String? _accessToken;

  Future<String?> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return null;
      } else {
        _logger.e('Error during registration: ${response.body}');
        final errorResponse = jsonDecode(response.body);
        return errorResponse['error'] ?? 'Registration failed';
      }
    } catch (error) {
      _logger.e('Error during registration: $error');
      return 'Registration failed: $error';
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _accessToken = responseBody['accessToken'];
        return null;
      } else {
        final responseBody = jsonDecode(response.body);
        return responseBody['error'] ?? 'Login failed';
      }
    } catch (error) {
      return 'Login failed: $error';
    }
  }

    Future<String?> logoutUser(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/user/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        _accessToken = null;
        return null;
      } else {
        _logger.e('Error during logout: ${response.body}');
        final errorResponse = jsonDecode(response.body);
        return errorResponse['error'] ?? 'Logout failed';
      }
    } catch (error) {
      _logger.e('Error during logout: $error');
      return 'Logout failed: $error';
    }
  }

  String? getAccessToken() {
    return _accessToken;
  }
}