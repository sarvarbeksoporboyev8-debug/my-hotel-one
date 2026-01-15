import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/models.dart';
import '../../../data/services/mock_data_service.dart';

class AuthProvider with ChangeNotifier {
  static const String _userKey = 'user_profile';
  
  final MockDataService _mockService = MockDataService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        _user = User(
          id: userData['id'] ?? '',
          name: userData['name'] ?? '',
          email: userData['email'] ?? '',
          avatar: userData['avatar'],
          phone: userData['phone'],
        );
        notifyListeners();
      } catch (e) {
        // Invalid saved data, ignore
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _mockService.login(email, password);
      if (success) {
        _user = _mockService.currentUser;
        await _saveUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _mockService.register(
        name: name,
        email: email,
        password: password,
      );
      if (success) {
        _user = _mockService.currentUser;
        await _saveUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _user = User(
        id: _user?.id ?? 'user_001',
        name: name,
        email: email,
        avatar: _user?.avatar,
        phone: phone,
      );
      
      await _saveUser();
      _mockService.updateUser(_user!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveUser() async {
    if (_user == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'id': _user!.id,
      'name': _user!.name,
      'email': _user!.email,
      'avatar': _user!.avatar,
      'phone': _user!.phone,
    };
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<void> logout() async {
    _mockService.logout();
    _user = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
