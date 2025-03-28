import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../auth/auth_service.dart';
import '../firebase/model_based/user_service.dart';

class UserProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;
  bool isAuthenticated = false;

  void setUser(User user) {
    this.user = user;
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      final authUser = _authService.getCurrentUser();
      if (authUser == null) {
        isAuthenticated = false;
        user = null;
        notifyListeners();
        return;
      }

      final firestoreUser = await UserService().getDocument(authUser.uid);
      if (firestoreUser != null) {
        user = _authService.mergeUserData(authUser, firestoreUser);
        isAuthenticated = true;
        notifyListeners();
        return;
      } else {
        user = null;
        notifyListeners();
        return;
      }
    } catch (e) {
      isAuthenticated = false;
      user = null;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      user = null;
      isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String? getUserId() {
    return user?.id;
  }
}
