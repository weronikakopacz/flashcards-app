import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLoginState(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

Future<bool> readLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<void> saveAccessToken(String accessToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
}

Future<String?> readAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<void> clearAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
}