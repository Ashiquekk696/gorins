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
