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

  /// Auth Methods

  /// Signs in a user with the provided [email] and [password].
  ///
  /// Attempts to authenticate the user using Firebase authentication. If the sign-in
  /// is successful, the method returns a [UserCredential] object representing the signed-in user.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs during sign-in, such as:
  /// - `user-not-found`: No user found for the provided email.
  /// - `wrong-password`: The password is incorrect.
  /// - An unexpected error.
  ///
  /// Logs the user's UID upon successful authentication.
  ///
  /// Returns a [UserCredential] object.

  /// Signs in a user with the provided [email] and [password].
  ///
  /// If the sign-in is successful, the method returns a [UserCredential] object representing the signed-in user.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs during sign-in, such as:
  /// - `user-not-found`: No user found for the provided email.
  /// - `wrong-password`: The password is incorrect.
  /// - An unexpected error.
  ///
  /// Logs the user's UID upon successful authentication.
  ///
  /// Returns a [UserCredential] object.
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

  /// Signs up a user with the provided [email] and [password].
  ///
  /// If the sign-up is successful, the method returns a [UserCredential] object representing the signed-up user.
  ///
  /// Throws a [FirebaseAuthException] if an error occurs during sign-up, such as:
  /// - `email-already-in-use`: The email is already in use by another user.
  /// - An unexpected error.
  ///
  /// Logs the user's UID upon successful authentication.
  ///
  /// Returns a [UserCredential] object.
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

/*************  ✨ Codeium Command ⭐  *************/
  /// Saves the user's details to the Firestore database.
  ///
  /// This method takes four parameters:
  /// - [userId]: The user's ID.
  /// - [username]: The user's chosen username.
  /// - [email]: The user's email address.
  /// - [imageUrl]: The URL of the user's profile picture. If null, the profile picture is not stored.
  ///
  /// The method creates a new document in the 'users' collection with the given [userId] as its document ID.
  /// The document contains the following fields:
  /// - 'userId': The user's ID.
  /// - 'username': The user's chosen username.
  /// - 'email': The user's email address.
  /// - 'profile_pic': The URL of the user's profile picture.
  /// - 'createdAt': The timestamp when the user signed up.
  ///
  /// If an error occurs during the saving process, the method does not throw an exception.
  /// Instead, it logs the error message.
/******  33acc351-bf57-40c5-b537-dcbfc16ed4e4  *******/
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

/// Streams a list of [UserModel] from the 'users' collection in Firestore.
///
/// This method listens to real-time updates from the 'users' collection.
/// Whenever there is a change in the collection, a new list of [UserModel]
/// is emitted. Each document in the 'users' collection is expected to map
/// to a [UserModel] object.
///
/// Returns a [Stream] that emits a [List<UserModel>] upon any change in
/// the 'users' collection.

Stream<List<UserModel>> streamUsersList() {
  return _firestore.collection('users').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();
  });
}

  /// Uploads a given [File] to the 'images' bucket in Firebase Storage and
  /// returns the download URL of the uploaded image.
  ///
  /// If the [File] is null, the method returns an empty string.
  ///
  /// If an error occurs during the upload process, the method logs the error
  /// message and returns an empty string.
  ///
  /// The image is uploaded with a unique name in the format of
  /// `${DateTime.now()}.jpeg`.
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
