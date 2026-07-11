import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get isDriver => _user?.role == UserRole.driver;
  bool get isPassenger => _user?.role == UserRole.passenger;

  Future<void> init() async {
    _user = await _authService.getCurrentUserModel();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.login(email: email, password: password);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _friendlyAuthError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    _setLoading(true);
    try {
      _user = await _authService.register(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _friendlyAuthError(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> updateSelectedStop(String stopId) async {
    if (_user == null) return;
    await _authService.updateSelectedStop(_user!.id, stopId);
    _user = _user!.copyWith(selectedStopId: stopId);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _friendlyAuthError(dynamic error) {
    final message = error.toString();
    if (message.contains('api-key-not-valid')) {
      return 'Firebase API key is invalid. Open lib/firebase_options_local.dart '
          'and paste your real keys from Firebase Console, then restart the app.';
    }
    if (message.contains('user-not-found') ||
        message.contains('wrong-password') ||
        message.contains('invalid-credential')) {
      return 'Invalid email or password.';
    }
    if (message.contains('email-already-in-use')) {
      return 'This email is already registered.';
    }
    if (message.contains('weak-password')) {
      return 'Password is too weak. Use at least 6 characters.';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Check your internet connection.';
    }
    return message.replaceAll(RegExp(r'\[.*?\]\s*'), '').trim();
  }
}
