import 'dart:io';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorins/routes.dart';
import 'package:gorins/core/network/firebase_manager.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseHelper _firebaseHelper;

  AuthProvider(
    this._firebaseHelper,
  );
  File? selectedImage;
  XFile? pickedFile;
  String? profileImageUrl;
  bool _isLoading = false;
  bool _isImageUploading = false;
  bool get isLoading => _isLoading;
  bool get isImageUploading => _isImageUploading;
  String? base64Image;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Stream<User?> get userStream => _firebaseHelper.authStateChanges;
  final ImagePicker imagePicker = ImagePicker();
  // Sign-in function
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    notifyListeners();
    _errorMessage = null;
    try {
      await _firebaseHelper.signInWithEmailPassword(email, password);
      _setLoading(false);
      showToast("Login successful!");
      if (context.mounted) {
        Navigator.pushNamed(context, Routes.home);
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _errorMessage = e.message;
      showToast(e.message ?? "Error signing in: ${e.message}");
      notifyListeners();
    }
  }

  Future signUp(
      {required String email,
      required String password,
      required String username,
      BuildContext? context}) async {
    try {
      _setLoading(true);
      UserCredential result = await _firebaseHelper.signUpWithEmailPassword(
        email,
        password,
      );
      User? user = result.user;

      if (user != null) {
        await _firebaseHelper.saveUserDetails(
            userId: user.uid,
            username: username,
            email: email,
            imageUrl: profileImageUrl ?? "");
        // Return the Firebase User
      }
      showToast("Signup successful!");
      if (context!.mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _errorMessage = e.message;
      showToast(e.message ?? "Error Signing up: ${e.message}");
      notifyListeners();
      return null;
    }
  }

  Future signout({BuildContext? context}) async {
    try {
      _setLoading(true);
      await _firebaseHelper.signOut();
      showToast("Signout successful!");
      if (context!.mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      _errorMessage = e.message;
      showToast(e.message ?? "Error Signing up: ${e.message}");
      notifyListeners();
      return null;
    }
  }

  Future<void> pickProfileImage() async {
    try {
      pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile?.path != null) {
        _setImageUploading(true);
        selectedImage = File(pickedFile?.path ?? ""); //

        profileImageUrl = await _firebaseHelper.uploadImage(selectedImage);
        _isImageUploading = false;
        notifyListeners();
      }
    } catch (e) {
      //
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setImageUploading(bool value) {
    _isImageUploading = value;
    notifyListeners();
  }
}
