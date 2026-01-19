import 'package:flutter/material.dart';
import 'package:boat_sched/models/schedule.dart';
import 'package:boat_sched/services/schedule_service.dart';

class CreateScheduleScreen extends StatefulWidget {
  const CreateScheduleScreen({super.key});

  @override
  State<CreateScheduleScreen> createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final ScheduleService _scheduleService = ScheduleService();
  final _noteController = TextEditingController();

  final List<String> _timeOptions = [
    '09:00:00',
    '10:00:00',
    '11:00:00',
    '13:00:00',
    '14:00:00',
    '15:00:00',
    '16:00:00',
    '17:00:00',
  ];

  final List<int> _paxOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final List<String> _purposeOptions = ['관광', '낚시', '화물운송', '기타'];

  String? _selectedTime;
  int? _selectedPax;
  String? _selectedPurpose;
  bool _isLoading = false;

  DateTime get _tomorrow => DateTime.now().add(const Duration(days: 1));

  Future<void> _handleSubmit() async {
    if (_selectedTime == null ||
        _selectedPax == null ||
        _selectedPurpose == null) {
      _showError('Please fill all required fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final schedule = Schedule(
        id: 0,
        userId: 0,
        storeName: '',
        representativeName: '',
        phoneNumber: '',
        scheduleDate: _tomorrow,
        scheduleTime: _selectedTime!,
        paxCount: _selectedPax!,
        purpose: _selectedPurpose!,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
        status: 'REQUESTED',
      );

      await _scheduleService.createSchedule(schedule);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule created successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        title: const Text('Create Schedule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Schedule Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_tomorrow.year}-${_tomorrow.month.toString().padLeft(2, '0')}-${_tomorrow.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Schedules can only be created for the next day',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Time *',
                border: OutlineInputBorder(),
              ),
              value: _selectedTime,
              items: _timeOptions.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time.substring(0, 5)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedTime = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Number of Passengers *',
                border: OutlineInputBorder(),
              ),
              value: _selectedPax,
              items: _paxOptions.map((pax) {
                return DropdownMenuItem(
                  value: pax,
                  child: Text('$pax'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedPax = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Purpose *',
                border: OutlineInputBorder(),
              ),
              value: _selectedPurpose,
              items: _purposeOptions.map((purpose) {
                return DropdownMenuItem(
                  value: purpose,
                  child: Text(purpose),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedPurpose = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
