import 'dart:convert';
import 'package:boat_sched/models/system_config.dart';
import 'package:boat_sched/services/api_service.dart';

class SystemConfigService {
  final ApiService _apiService = ApiService();

  Future<SystemConfig> getConfig() async {
    final response = await _apiService.get('/system/config', includeAuth: false);

    if (response.statusCode == 200) {
      return SystemConfig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch system config');
    }
  }

  Future<SystemConfig> updateConfig(SystemConfig config) async {
    final response = await _apiService.put(
      '/system/config',
      config.toJson(),
    );

    if (response.statusCode == 200) {
      return SystemConfig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update system config');
    }
  }
}
