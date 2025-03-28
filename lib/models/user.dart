import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  // Factory method to create a User object from a Firebase document snapshot
  factory User.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      createdAt: data['created_at'] != null ? data['created_at'].toDate() : DateTime.now(),
    );
  }

  // Method to convert a User object to a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toFirebase() {
    return toMap();
  }
}
