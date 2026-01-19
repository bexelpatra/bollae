import 'package:flutter/material.dart';
import 'package:boat_sched/models/system_config.dart';
import 'package:boat_sched/services/system_config_service.dart';

class ManagerConfigScreen extends StatefulWidget {
  const ManagerConfigScreen({super.key});

  @override
  State<ManagerConfigScreen> createState() => _ManagerConfigScreenState();
}

class _ManagerConfigScreenState extends State<ManagerConfigScreen> {
  final SystemConfigService _configService = SystemConfigService();
  final _noticeTitleController = TextEditingController();
  final _noticeContentController = TextEditingController();
  final _popupContentController = TextEditingController();

  bool _isDangerMode = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _configService.getConfig();
      if (mounted) {
        setState(() {
          _noticeTitleController.text = config.noticeTitle ?? '';
          _noticeContentController.text = config.noticeContent ?? '';
          _popupContentController.text = config.popupContent ?? '';
          _isDangerMode = config.isDangerMode;
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

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      final config = SystemConfig(
        noticeTitle: _noticeTitleController.text.isNotEmpty
            ? _noticeTitleController.text
            : null,
        noticeContent: _noticeContentController.text.isNotEmpty
            ? _noticeContentController.text
            : null,
        popupContent: _popupContentController.text.isNotEmpty
            ? _popupContentController.text
            : null,
        isDangerMode: _isDangerMode,
      );

      await _configService.updateConfig(config);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuration saved')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Danger Mode'),
              subtitle: const Text(
                'When enabled, all users will see a red background and receive a notification',
              ),
              value: _isDangerMode,
              onChanged: (value) => setState(() => _isDangerMode = value),
              activeColor: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'Notice',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noticeTitleController,
              decoration: const InputDecoration(
                labelText: 'Notice Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noticeContentController,
              decoration: const InputDecoration(
                labelText: 'Notice Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            const Text(
              'Popup Alert',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _popupContentController,
              decoration: const InputDecoration(
                labelText: 'Popup Content',
                helperText:
                    'If not empty, users will see this popup when opening the app',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveConfig,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noticeTitleController.dispose();
    _noticeContentController.dispose();
    _popupContentController.dispose();
    super.dispose();
  }
}
