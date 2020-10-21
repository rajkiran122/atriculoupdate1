import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String fullName;
  String email;
  String firstPassword;
  String confirmPassword;
  bool isRegisterInProgress = false;
  bool isPasswordShowing = false;

  toggleRegisterProgress() {
    isRegisterInProgress = !isRegisterInProgress;
    notifyListeners();
  }

  makeLoadingFalse() {
    isRegisterInProgress = false;
    notifyListeners();
  }

  nullifyAll() {
    fullName = null;
    email = null;
    firstPassword = null;
    confirmPassword = null;
    notifyListeners();
  }

  togglePasswordShowing() {
    isPasswordShowing = !isPasswordShowing;
    notifyListeners();
  }

  setFullName(value) {
    fullName = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setFirstPassword(value) {
    firstPassword = value;
    notifyListeners();
  }

  setConfirmPassword(value) {
    confirmPassword = value;
    notifyListeners();
  }
}
