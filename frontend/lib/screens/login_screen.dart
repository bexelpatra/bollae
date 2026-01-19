import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boat_sched/services/auth_service.dart';
import 'package:boat_sched/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _phoneController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _repNameController = TextEditingController();
  bool _isRegistering = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty) {
      _showError('Please enter phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(_phoneController.text);
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        Navigator.pushReplacementNamed(
          context,
          user.isManager ? '/manager-dashboard' : '/user-home',
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRegister() async {
    if (_phoneController.text.isEmpty ||
        _storeNameController.text.isEmpty ||
        _repNameController.text.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.register(
        _phoneController.text,
        _storeNameController.text,
        _repNameController.text,
      );
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        Navigator.pushReplacementNamed(context, '/user-home');
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
        title: const Text('Boat Sched'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            if (_isRegistering) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Store Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _repNameController,
                decoration: const InputDecoration(
                  labelText: 'Representative Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_isRegistering ? _handleRegister : _handleLogin),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_isRegistering ? 'Register' : 'Login'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() => _isRegistering = !_isRegistering);
              },
              child: Text(_isRegistering
                  ? 'Already have an account? Login'
                  : 'New user? Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _storeNameController.dispose();
    _repNameController.dispose();
    super.dispose();
  }
}
