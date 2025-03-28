import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../firebase/model_based/user_service.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final UserService _userService = UserService();

  auth.User? getCurrentUser() => _firebaseAuth.currentUser;
  Future<void> signOut() async => await _firebaseAuth.signOut();

  // Function to merge data from Firebase Auth credentials and Firestore document
  User mergeUserData(auth.User firebaseUser, User firestoreUser) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? firestoreUser.email,
      username: firestoreUser.username,
      createdAt: firestoreUser.createdAt,
    );
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('Attempting to sign in with email: $email');

      auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth.User firebaseUser = userCredential.user!;

      // Fix User DocumentSnapshot cast error
      debugPrint('Successfully signed in. UID: ${firebaseUser.uid}');
      User? firebaseUserObject = await _userService.getDocument(firebaseUser.uid);

      if (firebaseUserObject != null) {
        debugPrint('User document found in Firestore. Merging data.');

        User mergedUser = mergeUserData(firebaseUser, firebaseUserObject);
        debugPrint('User data merged successfully.');

        return mergedUser;
      } else {
        debugPrint('User document does not exist in Firestore.');
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return null;
    }
  }

  Future<bool> registerUser(String mail, String password) async {
    try {
      debugPrint('Attempting to register with email: $mail');
      final response = await _firebaseAuth.createUserWithEmailAndPassword(email: mail, password: password);
      if (response.user != null) {
        return true;
      }
    } catch (e) {
      debugPrint('Unexpected error: $e.');
    }
    return false;
  }
}
