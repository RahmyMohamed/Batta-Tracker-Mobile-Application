import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      id: credential.user!.uid,
      email: email,
      name: name,
      phone: phone,
      role: role,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userModel.id)
        .set(userModel.toMap());

    if (role == UserRole.driver) {
      await _firestore
          .collection(AppConstants.driversCollection)
          .doc(userModel.id)
          .set({
        'userId': userModel.id,
        'name': name,
        'phone': phone,
        'isActive': true,
        'routeId': AppConstants.defaultRouteId,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    return userModel;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(credential.user!.uid)
        .get();

    if (!doc.exists) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User profile not found.',
      );
    }

    return UserModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> logout() => _auth.signOut();

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> updateSelectedStop(String userId, String stopId) async {
    await _firestore.collection(AppConstants.usersCollection).doc(userId).update({
      'selectedStopId': stopId,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
