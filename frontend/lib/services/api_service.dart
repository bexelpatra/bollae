import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.73:8080/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      String? token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> delete(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return response;
  }
}
