import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net';

  static Future<Map<String, dynamic>?> confirmCode(String email, String code) async {
    try {
      print('Отправляем код подтверждения:');
      print('Email: $email');
      print('Code: $code');

      final response = await http.post(
        Uri.parse('$baseUrl/confirm_code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      print('Ответ сервера:');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Успешный ответ: $responseData');
        return responseData;
      } else {
        print('Ошибка сервера: ${response.statusCode}');
        print('Тело ошибки: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Исключение: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh_token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Refresh token error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Refresh token exception: $e');
      return null;
    }
  }

  static Future<String?> getUserId(String jwtToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth'),
        headers: {
          'Auth': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['user_id']?.toString();
      } else {
        print('Get user id error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get user id exception: $e');
      return null;
    }
  }
}