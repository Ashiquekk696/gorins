import 'package:flutter/material.dart'; 
import 'package:gorins/data/models/user_model.dart';
import 'package:gorins/core/network/firebase_manager.dart';

class HomeProvider with ChangeNotifier {
  final FirebaseHelper _firebaseHelper;
  HomeProvider(this._firebaseHelper) {
    _setupUserStream();
  }
   List<UserModel> _usersList = [];
  List<UserModel> get usersList => _usersList;
  /// Sets up a stream to listen to the list of users in Firebase Firestore.
  ///
  /// When the stream emits a new list of users, it updates the [_usersList]
  /// field with that list and notifies the listeners.
  void _setupUserStream() {
    _firebaseHelper.streamUsersList().listen(
      (data) {
        _usersList = data;  
        notifyListeners();  
      },
      onError: (error) {
      },
    );}
}
