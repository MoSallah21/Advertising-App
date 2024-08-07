import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn({required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User?> register({required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UsersModel?> getUserData(String uId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(uId).get();
      if (userDoc.exists) {
        return UsersModel.fromJson(userDoc.data() as Map<String, dynamic>?);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> createUser(UsersModel user) async {
    await _firestore.collection('user').doc(user.uId).set(user.toMap());
  }
}
