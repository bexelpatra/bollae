import 'package:flutter/material.dart';
import 'package:boat_sched/models/schedule.dart';
import 'package:boat_sched/services/schedule_service.dart';

class MySchedulesScreen extends StatefulWidget {
  const MySchedulesScreen({super.key});

  @override
  State<MySchedulesScreen> createState() => _MySchedulesScreenState();
}

class _MySchedulesScreenState extends State<MySchedulesScreen> {
  final ScheduleService _scheduleService = ScheduleService();
  List<Schedule> _schedules = [];
  bool _isLoading = true;
  String? _filterStatus;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoading = true);
    try {
      final schedules = await _scheduleService.getSchedules(status: _filterStatus);
      if (mounted) {
        setState(() {
          _schedules = schedules;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError(e.toString());
      }
    }
  }

  Future<void> _cancelSchedule(int id) async {
    try {
      await _scheduleService.cancelSchedule(id);
      _loadSchedules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule canceled')),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedules'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(value: 'REQUESTED', label: Text('Requested')),
                ButtonSegment(value: 'APPROVED', label: Text('Approved')),
                ButtonSegment(value: 'CANCELED', label: Text('Canceled')),
              ],
              selected: {_filterStatus},
              onSelectionChanged: (Set<String?> newSelection) {
                setState(() {
                  _filterStatus = newSelection.first;
                  _loadSchedules();
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _schedules.isEmpty
                    ? const Center(child: Text('No schedules found'))
                    : RefreshIndicator(
                        onRefresh: _loadSchedules,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = _schedules[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${schedule.scheduleDate.year}-${schedule.scheduleDate.month.toString().padLeft(2, '0')}-${schedule.scheduleDate.day.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Chip(
                                          label: Text(schedule.status),
                                          backgroundColor: schedule.isApproved
                                              ? Colors.green.shade100
                                              : schedule.isCanceled
                                                  ? Colors.red.shade100
                                                  : Colors.orange.shade100,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Time: ${schedule.scheduleTime.substring(0, 5)}'),
                                    Text('Passengers: ${schedule.paxCount}'),
                                    Text('Purpose: ${schedule.purpose}'),
                                    if (schedule.note != null) ...[
                                      const SizedBox(height: 4),
                                      Text('Note: ${schedule.note}'),
                                    ],
                                    if (schedule.isRequested) ...[
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: () => _cancelSchedule(schedule.id),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
