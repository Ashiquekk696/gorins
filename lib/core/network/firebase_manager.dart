import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../data/models/user_model.dart';

class FirebaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Singleton pattern
  static final FirebaseHelper _instance = FirebaseHelper._internal();

  factory FirebaseHelper() {
    return _instance;
  }

  FirebaseHelper._internal();

  // Auth Methods

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Error fetching current user: $e',
      );
    }
  }

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential a = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("hhh ${a.user?.uid}");
      return a;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Incorrect password.',
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Error signing in: ${e.message}',
        );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
          code: e.code,

          /// Stream of document snapshots with the given [docId] from the given [collection].
          ///
          /// This can be used to listen to real-time data from a single document.
          message: 'The email is already in use.',
        );
      } else {
        throw FirebaseAuthException(
          code: e.code,
          message: 'Error signing up: ${e.message}',
        );
      }
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

Future<void> saveUserDetails({
  required String userId,
  required String username,
  required String email,
  String? imageUrl,
}) async {
  try {
    // Save user details under their own document
    await _firestore.collection('users').doc(userId).set({
      'userId': userId,          // Store the user's ID
      'username': username,      // Store the username
      'email': email,            // Store the email
      'profile_pic': imageUrl,   // Store the profile picture URL
      'createdAt': Timestamp.now(), // Store the creation timestamp
    }); 
  } catch (e) {
   //
  }
}


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Error signing out: $e',
      );
    }
  }

  // Firestore Methods

Stream<List<UserModel>> streamUsersList() {
  return _firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();
  });
}

  Future<String> uploadImage(File? selectedImage) async {
    if (selectedImage == null) {
      return "";
    }

    try {
      final storageRef =
          _storage.ref().child("images").child('${DateTime.now()}.jpeg');
      await storageRef.putFile(selectedImage);

      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return "";
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
