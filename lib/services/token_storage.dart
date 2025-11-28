import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _jwtKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _emailKey = 'user_email';

  static Future<void> saveJwt(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtKey, jwt);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> saveTokens(String jwt, String refreshToken, {String? email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_jwtKey, jwt);
      await prefs.setString(_refreshTokenKey, refreshToken);
      if (email != null) {
        await prefs.setString(_emailKey, email);
      }
      
      print('Токены сохранены:');
      print('JWT: ${jwt.substring(0, 20)}...');
      print('Refresh Token: ${refreshToken.substring(0, 20)}...');
      print('Email: $email');
    } catch (e) {
      print('Ошибка сохранения токенов: $e');
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtKey) != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_emailKey);
  }
}