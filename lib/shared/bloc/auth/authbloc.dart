import 'package:adphotos/models/user/user.dart';
import 'package:adphotos/shared/bloc/auth/authstatus.dart';
import 'package:adphotos/shared/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firesbase_storage;


class AuthBloc extends Cubit<AuthState> {
  AuthBloc(): super(AuthInitState());
  static AuthBloc get(context) => BlocProvider.of(context);
  UsersModel? userModel;

  void getUserData() {
    emit(AuthGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .snapshots()
        .listen((value) {
      if(value.data()!=null){
        userModel = UsersModel.fromJson(value.data());
        emit(AuthGetUserSuccessState());}
      else
        getUserData();
    }, onError: (onError) {
      emit(AuthGetUserErrorState(onError.toString()));
    });
  }
  // sign in process
  void signIn({required String email,
    required String password})
  {
    emit(AuthLoadingLoginState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      uId=value.user!.uid;
      emit(AuthSuccessLoginState(value.user!.uid));
      getUserData();
    }).catchError(
            (onError)
        {
          emit(AuthErrorLoginState(onError.toString()));
        }
    );
  }
  // show or not login
  IconData suffix= Icons.visibility_outlined;
  bool isShowLogin = true;
  void loginChangePasswordToShow() {
    isShowLogin = !isShowLogin;
    suffix= isShowLogin ? Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(AuthSignInChangeToShowState());
  }
  //show or not register
  IconData suffixx=Icons.visibility_outlined;
  bool isShowSignUp = true;
  void registerChangePasswordToShow() {
    isShowSignUp = !isShowSignUp;
    suffixx= isShowSignUp ? Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(AuthRegisterChangeToShowState());
  }
  //register process
  void userRegister({
    required String name,
    required String num,
    required String email,
    required String password,
  })
  {
    emit(AuthLoadingRegisterState());
    FirebaseAuth.
    instance.
    createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      userCreate(
          name: name,
          num: num,
          email: email,
          uId: value.user!.uid);
    });
  }
  // create user and get the uid process
  void userCreate({
    required String name,
    required String email,
    required String num,
    required String uId,
  })
  {
    UsersModel model =UsersModel(
      username: name,
      email: email,
      num: num,
      uId: uId,
    );

    FirebaseFirestore.instance.collection('user')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(AuthSuccessCreateUserState());
    })
        .catchError((onError){
      emit(AuthErrorCreateState(onError.toString()));
    });
  }
  // rest password
  Future<void> resetPassword({required String email}) async {
    emit(AuthLoadingRestPasswordState());
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      emit(AuthSuccessRestPasswordState());
    }).catchError((error){
      emit(AuthErrorRestPasswordState(error));
    });
  }

}