import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;

import '../../../models/user.dart';
import '../../../utils/constants/firebase_constants.dart';
import '../firebase_crud_service.dart';

class UserService extends FirestoreCrudService<User> {
  UserService()
      : super(
          collectionPath: FirebaseConstant.userCollection,
          fromMap: (doc) => User.fromMap(doc),
          toMap: (user) => user.toMap(),
        );

  Future<void> incrementUserScore(String uid, int score) async {
    await getFirestoreInstance().collection(collectionPath).doc(uid).update(
      {
        'score': FieldValue.increment(score),
      },
    );
  }

  Future<void> sendUserInfoToFirestore(String email, {bool update = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final uid = user.uid;

    final data = {'email': email};

    if (update) {
      await getFirestoreInstance().collection(collectionPath).doc(uid).update(data);
    } else {
      await getFirestoreInstance().collection(collectionPath).doc(uid).set({
        ...data,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
    }
  }

  Future<User?> getUser(String userID) async {
    try {
      DocumentSnapshot doc = await getFirestoreInstance().collection(collectionPath).doc(userID).get();

      if (!doc.exists) return null;

      User user = User.fromMap(doc as DocumentSnapshot<Map<String, dynamic>>);
      return user;
    } catch (e) {
      return null;
    }
  }
}
