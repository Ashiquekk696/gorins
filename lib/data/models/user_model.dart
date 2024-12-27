import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String email;
  final String? profilePic;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.profilePic,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] as String,
      username: data['username'] as String,
      email: data['email'] as String,
      profilePic: data['profile_pic'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
