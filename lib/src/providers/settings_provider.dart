import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  bool _focusMode = false;
  bool _largerText = false;
  bool _highContrast = false;

  bool get focusMode => _focusMode;
  bool get largerText => _largerText;
  bool get highContrast => _highContrast;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final focus = await _storage.read(key: 'focus_mode');
    final larger = await _storage.read(key: 'larger_text');
    final contrast = await _storage.read(key: 'high_contrast');

    _focusMode = focus == 'true';
    _largerText = larger == 'true';
    _highContrast = contrast == 'true';
    
    notifyListeners();
  }

  Future<void> toggleFocusMode(bool value) async {
    _focusMode = value;
    await _storage.write(key: 'focus_mode', value: value.toString());
    notifyListeners();
  }

  Future<void> toggleLargerText(bool value) async {
    _largerText = value;
    await _storage.write(key: 'larger_text', value: value.toString());
    notifyListeners();
  }

  Future<void> toggleHighContrast(bool value) async {
    _highContrast = value;
    await _storage.write(key: 'high_contrast', value: value.toString());
    notifyListeners();
  }
}
