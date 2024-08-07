import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adphotos/models/user/user.dart';

class UserRepository {
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
