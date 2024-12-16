import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> login(String email, String password) async {
    // Implement login logic
    state = true;
  }

  Future<void> logout() async {
    // Implement logout logic
    state = false;
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    // Implement password change logic
  }

  Future<void> register(String email, String password, String name) async {
    // Implement registration logic
    state = true;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
