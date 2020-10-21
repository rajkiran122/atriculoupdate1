import 'package:flutter/material.dart';

class TextFormFieldProvider with ChangeNotifier {
  bool isSignUpPage = false;

  toggleSIGNUP() {
    isSignUpPage = !isSignUpPage;
    notifyListeners();
  }

  makeSignUpFalse() {
    isSignUpPage = false;
    notifyListeners();
  }

  changePadding() {
    notifyListeners();
  }
}
