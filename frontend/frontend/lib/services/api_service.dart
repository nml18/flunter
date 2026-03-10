import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Future<Map<String, dynamic>> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message']};
      }
      else {
        return {'success': false, 'error': data['error'] ?? 'Unknown error'};
      }
    }
    catch (e) {
      return {'success': false, 'error': 'Network error'};
    }
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Invalid credentials'};
      }
    }
    catch (e) {
      return {'success': false, 'error': 'Network error'};
    }
  }
}