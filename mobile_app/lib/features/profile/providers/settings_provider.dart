import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _emailNotificationsKey = 'email_notifications';
  static const String _pushNotificationsKey = 'push_notifications';
  static const String _promoNotificationsKey = 'promo_notifications';
  static const String _languageKey = 'language';
  static const String _currencyKey = 'currency';

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _promoNotifications = false;
  String _language = 'English';
  String _currency = 'USD';

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  bool get promoNotifications => _promoNotifications;
  String get language => _language;
  String get currency => _currency;

  String get currencySymbol {
    switch (_currency) {
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return '\$';
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _emailNotifications = prefs.getBool(_emailNotificationsKey) ?? true;
    _pushNotifications = prefs.getBool(_pushNotificationsKey) ?? true;
    _promoNotifications = prefs.getBool(_promoNotificationsKey) ?? false;
    _language = prefs.getString(_languageKey) ?? 'English';
    _currency = prefs.getString(_currencyKey) ?? 'USD';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  Future<void> setEmailNotifications(bool value) async {
    _emailNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailNotificationsKey, value);
  }

  Future<void> setPushNotifications(bool value) async {
    _pushNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushNotificationsKey, value);
  }

  Future<void> setPromoNotifications(bool value) async {
    _promoNotifications = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_promoNotificationsKey, value);
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, value);
  }

  Future<void> setCurrency(String value) async {
    _currency = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, value);
  }
}
