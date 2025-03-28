import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import '../../api/firebase/firebase_options.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<bool> addPushTokenToFirestore(String token) async {
    CollectionReference usersCol = _firestore.collection("pushtokens");
    try {
      await usersCol.doc(token).set({
        "devtoken": token,
      });
      return true;
    } catch (e) {
      debugPrint('Failed to add push token to Firestore: $e');
      return false;
    }
  }

  Future<bool> isCompany(user) async {
    try {
      final email = user.email;
      final snapshot = await _firestore.collection("company").doc(email).get();

      if (snapshot.exists) {
        true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to check if user is company: $e');
      return false;
    }
  }

  static Future<DocumentSnapshot?> getConfig() async {
    try {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection("config").doc("kariyer-fuari").get();
      return docSnap;
    } catch (e) {
      debugPrint('Failed to get config: $e');
      return null;
    }
  }

  static Stream<DocumentSnapshot?>? listenConfig() {
    try {
      Stream<DocumentSnapshot?>? configSnapshot = FirebaseFirestore.instance.collection("config").doc("kariyer-fuari").snapshots();
      return configSnapshot;
    } catch (e) {
      debugPrint('Failed to get config: $e');
      return null;
    }
  }

  Future<bool> isUserAdmin(String email) async {
    try {
      final snapshot = await _firestore.collection("admins").doc(email).get();
      if (snapshot.exists) return true;
      return false;
    } catch (e) {
      debugPrint('Failed to check if user is admin: $e');
      return false;
    }
  }
}
