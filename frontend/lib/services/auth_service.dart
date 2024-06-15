import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthService {
  final Logger _logger = Logger();
  static const String baseUrl = 'http://localhost:8080';
  String? _accessToken;

  Future<String?> registerUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/register'),
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
        Uri.parse('$baseUrl/api/user/login'),
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
        Uri.parse('$baseUrl/api/user/logout'),
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

  Future<String?> fetchUserId(String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/userid');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final userId = jsonDecode(response.body);
        _logger.i('Fetched user id: $userId');
        return userId;
      } else {
        _logger.e('Failed to fetch user id: ${response.statusCode}');
        throw 'Failed to fetch user id: ${response.statusCode}';
      }
    } catch (error) {
      _logger.e('Error fetching user id: $error');
      throw 'Error fetching user id: $error';
    }
  }

  Future<String?> getUserEmail(String accessToken) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/email');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> userEmailMap = jsonDecode(response.body);
        final String userEmail = userEmailMap['email'];
        _logger.i('Fetched user email: $userEmail');
        return userEmail;
      } else {
        _logger.e('Failed to fetch user email: ${response.statusCode}');
        throw 'Failed to fetch user email: ${response.statusCode}';
      }
    } catch (error) {
      _logger.e('Error fetching user email: $error');
      throw 'Error fetching user email: $error';
    }
  }

  String? getAccessToken() {
    return _accessToken;
  }
}