import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _jwtKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _emailKey = 'user_email';

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String jwt, String refreshToken, {String? email}) async {
    try {
      await _storage.write(key: _jwtKey, value: jwt);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      if (email != null) {
        await _storage.write(key: _emailKey, value: email);
      }
      
      print('Токены безопасно сохранены:');
      print('JWT: ${jwt.substring(0, 20)}...');
      print('Refresh Token: ${refreshToken.substring(0, 20)}...');
      print('Email: $email');
    } catch (e) {
      print('Ошибка сохранения токенов: $e');
      throw e;
    }
  }

  static Future<String?> getJwt() async {
    try {
      return await _storage.read(key: _jwtKey);
    } catch (e) {
      print('Ошибка чтения JWT: $e');
      return null;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      print('Ошибка чтения Refresh Token: $e');
      return null;
    }
  }

  static Future<String?> getEmail() async {
    try {
      return await _storage.read(key: _emailKey);
    } catch (e) {
      print('Ошибка чтения Email: $e');
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final jwt = await getJwt();
      return jwt != null;
    } catch (e) {
      print('Ошибка проверки авторизации: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      await _storage.delete(key: _jwtKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _emailKey);
      print('Все токены удалены из безопасного хранилища');
    } catch (e) {
      print('Ошибка выхода: $e');
      throw e;
    }
  }

  static Future<void> debugPrintAllKeys() async {
    try {
      final allData = await _storage.readAll();
      print('Все ключи в Secure Storage:');
      allData.forEach((key, value) {
        print('$key: ${value.substring(0, 20)}...');
      });
    } catch (e) {
      print('Ошибка чтения всех ключей: $e');
    }
  }
}