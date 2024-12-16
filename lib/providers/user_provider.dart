import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../models/user.dart';
import '../services/firebase_service.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService());

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier(ref.read(firebaseServiceProvider));
});

class UserNotifier extends StateNotifier<User> {
  final FirebaseService _firebaseService;

  UserNotifier(this._firebaseService)
      : super(User(
          id: '',
          email: '',
          name: '',
          location: '',
          bio: '',
          photoUrl: null,
        )) {
    _initUser();
  }

  Future<void> _initUser() async {
    final user = await _firebaseService.getCurrentUser();
    if (user != null) {
      state = user;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String location,
    required String bio,
  }) async {
    final updatedUser = User(
      id: state.id,
      email: state.email,
      name: name,
      location: location,
      bio: bio,
      photoUrl: state.photoUrl,
    );

    await _firebaseService.updateUser(updatedUser);
    state = updatedUser;
  }

  Future<void> updateProfileImage(Uint8List imageBytes) async {
    final photoUrl =
        await _firebaseService.uploadProfileImage(state.id, imageBytes);
    final updatedUser = User(
      id: state.id,
      email: state.email,
      name: state.name,
      location: state.location,
      bio: state.bio,
      photoUrl: photoUrl,
    );

    await _firebaseService.updateUser(updatedUser);
    state = updatedUser;
  }
}
