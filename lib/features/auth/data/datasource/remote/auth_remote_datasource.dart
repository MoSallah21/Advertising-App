import 'package:adphotos/core/errors/exception.dart';
import 'package:adphotos/core/strings/constants.dart';
import 'package:adphotos/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:adphotos/features/auth/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource{
  Future<Unit> signup(String username, String email, String num, String password);

  Future<Unit> login(String email,String password);

  Future<UserModel> getUserData();

  Future<Unit> forgetPassword(String email);
}
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late final AuthLocalDatasource localDatasource;


class AuthRemoteDatasourceImpl implements AuthRemoteDatasource{
  @override
  Future<Unit> forgetPassword(String email)async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return Future.value(unit);

  }

  @override
  Future<UserModel> getUserData()async {
    DocumentSnapshot userDoc = await _firestore.collection('user').doc(uId).get();

    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>?);
    }
    else {
      throw ServerException();

    }


  }

  @override
  Future<Unit> login(String email, String password) async{
    UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if(userCredential.user!=null){
      localDatasource.cacheUserUid(userCredential.user!.uid);
      uId=userCredential.user!.uid;
      return Future.value(unit);
    }
    else{
      throw ServerException();
    }
  }

  @override
  Future<Unit> signup(String username, String email, String num, String password) async{
    UserCredential userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    if(userCredential.user!=null){
     UserModel userModel= UserModel(username: username, email: email, num: num, uId: userCredential.user!.uid);
      await _firestore.collection('user').doc(userModel.uId).set(userModel.toJson());
      return Future.value(unit);
    }
    else{
      throw ServerException();
    }

  }

  

}