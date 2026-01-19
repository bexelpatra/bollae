import 'package:flutter/foundation.dart';
import 'package:boat_sched/models/user.dart';
import 'package:boat_sched/models/system_config.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  SystemConfig? _systemConfig;

  User? get currentUser => _currentUser;
  SystemConfig? get systemConfig => _systemConfig;

  bool get isManager => _currentUser?.isManager ?? false;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setSystemConfig(SystemConfig config) {
    _systemConfig = config;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _systemConfig = null;
    notifyListeners();
  }
}
