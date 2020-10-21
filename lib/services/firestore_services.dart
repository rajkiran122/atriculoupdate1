import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prof_blog_app/models/user_model.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  createNewUser(UserModel model) async {
    await _db.collection('Users').doc(model.userId).set(model.toMap());
  }
}
