import 'dart:convert';
import 'package:boat_sched/models/schedule.dart';
import 'package:boat_sched/services/api_service.dart';

class ScheduleService {
  final ApiService _apiService = ApiService();

  Future<Schedule> createSchedule(Schedule schedule) async {
    final response = await _apiService.post(
      '/schedules',
      schedule.toJson(),
    );

    if (response.statusCode == 200) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to create schedule');
    }
  }

  Future<List<Schedule>> getSchedules({String? status}) async {
    String endpoint = '/schedules';
    if (status != null) {
      endpoint += '?status=$status';
    }

    final response = await _apiService.get(endpoint);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch schedules');
    }
  }

  Future<Schedule> getSchedule(int id) async {
    final response = await _apiService.get('/schedules/$id');

    if (response.statusCode == 200) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch schedule');
    }
  }

  Future<Schedule> approveSchedule(int id) async {
    final response = await _apiService.put('/schedules/$id/approve', {});

    if (response.statusCode == 200) {
      return Schedule.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to approve schedule');
    }
  }

  Future<void> cancelSchedule(int id) async {
    final response = await _apiService.delete('/schedules/$id');

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to cancel schedule');
    }
  }
}
