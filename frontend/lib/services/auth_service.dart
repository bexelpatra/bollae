import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:boat_sched/models/user.dart';
import 'package:boat_sched/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<User> register(String phoneNumber, String storeName, String representativeName) async {
    final response = await _apiService.post(
      '/auth/register',
      {
        'phoneNumber': phoneNumber,
        'storeName': storeName,
        'representativeName': representativeName,
      },
      includeAuth: false,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: data['token']);
      return User.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Registration failed');
    }
  }

  Future<User> login(String phoneNumber) async {
    final response = await _apiService.post(
      '/auth/login',
      {'phoneNumber': phoneNumber},
      includeAuth: false,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'jwt_token', value: data['token']);
      return User.fromJson(data);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    String? token = await _storage.read(key: 'jwt_token');
    return token != null;
  }

  Future<void> updateFcmToken(String fcmToken) async {
    await _apiService.put('/users/fcm-token', {'fcmToken': fcmToken});
  }
}
