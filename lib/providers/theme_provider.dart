import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_provider.dart';

final darkModeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(ref);
});

class ThemeNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final String _key = 'darkMode';

  ThemeNotifier(this._ref) : super(false) {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _ref.read(userProvider).id;

    if (userId.isNotEmpty) {
      final settings =
          await _ref.read(firebaseServiceProvider).getUserSettings(userId);

      if (settings != null && settings.containsKey('darkMode')) {
        state = settings['darkMode'];
        return;
      }
    }

    // Fallback to local storage if not in Firebase
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> toggle() async {
    final newState = !state;
    state = newState;

    // Save to Firebase if user is logged in
    final userId = _ref.read(userProvider).id;
    if (userId.isNotEmpty) {
      await _ref
          .read(firebaseServiceProvider)
          .updateUserSettings(userId, {'darkMode': newState});
    }

    // Also save to local storage as backup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newState);
  }
}
