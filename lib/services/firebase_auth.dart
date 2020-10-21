import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prof_blog_app/models/user_model.dart';
import 'package:prof_blog_app/services/firestore_services.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService _firestoreService = FirestoreService();

  createNewUser(UserModel model) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: model.email, password: model.password);
    User user = userCredential.user;
    if (user == null) {
      return;
    }
    await user.updateProfile(displayName: model.userName);
    await _firestoreService.createNewUser(UserModel(
      userId: user.uid,
      email: model.email,
      password: model.password,
      userName: model.userName,
    ));
    return user;
  }

  signInUser(UserModel model) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: model.email, password: model.password);
    User user = userCredential.user;
    return user;
  }
}
