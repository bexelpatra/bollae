import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boat_sched/models/system_config.dart';
import 'package:boat_sched/services/system_config_service.dart';
import 'package:boat_sched/services/auth_service.dart';
import 'package:boat_sched/providers/user_provider.dart';
import 'package:boat_sched/screens/create_schedule_screen.dart';
import 'package:boat_sched/screens/my_schedules_screen.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final SystemConfigService _configService = SystemConfigService();
  final AuthService _authService = AuthService();
  SystemConfig? _config;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await _configService.getConfig();
      if (mounted) {
        setState(() {
          _config = config;
          _isLoading = false;
        });

        if (config.popupContent != null && config.popupContent!.isNotEmpty) {
          _showPopup(config.popupContent!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPopup(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notice'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Provider.of<UserProvider>(context, listen: false).logout();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDangerMode = _config?.isDangerMode ?? false;
    final backgroundColor = isDangerMode ? Colors.red.shade50 : Colors.white;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Boat Sched'),
        backgroundColor: isDangerMode ? Colors.red.shade300 : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadConfig,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDangerMode)
                Card(
                  color: Colors.red.shade100,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'DANGER MODE ACTIVE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_config?.noticeTitle != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _config!.noticeTitle!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_config!.noticeContent != null) ...[
                          const SizedBox(height: 8),
                          Text(_config!.noticeContent!),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateScheduleScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Schedule'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MySchedulesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('My Schedules'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
