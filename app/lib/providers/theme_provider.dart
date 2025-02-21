import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<bool> {
  static const _key = 'is_dark_mode';
  late final SharedPreferences _prefs;

  ThemeNotifier() : super(true) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    state = _prefs.getBool(_key) ?? true;
  }

  Future<void> toggleTheme() async {
    state = !state;
    await _prefs.setBool(_key, state);
  }
}
