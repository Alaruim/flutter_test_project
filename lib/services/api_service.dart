import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://d5dsstfjsletfcftjn3b.apigw.yandexcloud.net';

  static Future<bool> sendCodeToEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending code: $e');
      return false;
    }
  }
}