import 'dart:io';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorins/routes.dart';
import 'package:gorins/core/network/firebase_manager.dart';
import 'package:image_picker/image_picker.dart';

/// AuthProvider class manages user authentication and profile image selection.
class AuthProvider with ChangeNotifier {
  final FirebaseHelper _firebaseHelper;

  /// Constructor for AuthProvider.
  ///
  /// [firebaseHelper] is required for Firebase authentication and other related operations.
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
  /// Signs in the user with the provided [email] and [password].
  ///
  /// If the sign-in attempt is successful, the user is redirected to the home page.
  /// If the sign-in attempt fails, an error message is displayed and the user remains on the same page.
  ///
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

  /// Signs up a user with the given [email], [password] and [username].
  ///
  /// If the sign-up attempt is successful, the user is redirected to the login page.
  /// If the sign-up attempt fails, an error message is displayed and the user remains on the same page.
  ///
  /// [context] is an optional parameter and is used to push the user to the login page after a successful sign-up.
  ///
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

/// Signs out the current user.
///
/// If the signout attempt is successful, a success message is displayed 
/// and the user is redirected to the login page.
/// If the signout attempt fails, an error message is displayed.
/// 
/// [context] is an optional parameter and is used to navigate the user 
/// to the login page after a successful signout.

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
      showToast(e.message ?? "Error Signing out: ${e.message}");
      notifyListeners();
      return null;
    }
  }

  /// Picks a profile image from the gallery, uploads it to Firebase, and updates the profile image URL.
  ///
  /// This method uses the ImagePicker to allow the user to select an image from their device's gallery.
  /// Once an image is selected, it is uploaded to Firebase Storage using the FirebaseHelper.
  /// The URL of the uploaded image is then stored in [profileImageUrl].
  ///
  /// The method updates the UI to indicate the image upload process using [_setImageUploading].
  /// Listeners are notified once the upload is complete or if an error occurs.
  ///
  /// If an error occurs during the image picking or uploading process, it is caught and handled silently.

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
