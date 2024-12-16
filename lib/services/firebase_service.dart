import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../models/user.dart';

class FirebaseService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User operations
  Future<User?> getCurrentUser() async {
    final auth.User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final doc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!doc.exists) return null;

    return User.fromMap(doc.data()!..['id'] = doc.id);
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.id).update({
      'name': user.name,
      'location': user.location,
      'bio': user.bio,
      'photoUrl': user.photoUrl,
    });
  }

  Future<String> uploadProfileImage(String userId, Uint8List imageBytes) async {
    final ref = _storage.ref().child('profile_images/$userId.jpg');
    await ref.putData(imageBytes);
    return await ref.getDownloadURL();
  }

  // Category operations
  Future<List<Map<String, dynamic>>> getCategories(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .get();

    return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
  }

  Future<void> addCategory(String userId, Map<String, dynamic> category) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .add(category);
  }

  Future<void> updateCategory(
      String userId, String categoryId, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .update(data);
  }

  Future<void> deleteCategory(String userId, String categoryId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  // Settings operations
  Future<void> updateUserSettings(
      String userId, Map<String, dynamic> settings) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('preferences')
        .set(settings, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('preferences')
        .get();

    return doc.data();
  }
}
