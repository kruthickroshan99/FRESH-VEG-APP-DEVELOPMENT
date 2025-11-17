import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.createdAt,
    this.lastLogin,
  });

  // Convert from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : FieldValue.serverTimestamp(),
    };
  }
}