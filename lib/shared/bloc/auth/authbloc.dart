import 'package:adphotos/data/services/auth_service.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:adphotos/shared/bloc/auth/authstatus.dart';
import 'package:adphotos/shared/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Cubit<AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitState());

  static AuthBloc get(context) => BlocProvider.of(context);

  UsersModel? userModel;

  void getUserData() {
    emit(AuthGetUserLoadingState());
    _authService.getUserData(uId).then((userData) {
      if (userData != null) {
        userModel = userData;
        emit(AuthGetUserSuccessState());
      } else {
        emit(AuthGetUserErrorState("User not found"));
      }
    }).catchError((error) {
      emit(AuthGetUserErrorState(error.toString()));
    });
  }

  void signIn({required String email, required String password}) {
    emit(AuthLoadingLoginState());
    _authService.signIn(email: email, password: password).then((user) {
      if (user != null) {
        uId = user.uid;
        emit(AuthSuccessLoginState(user.uid));
        getUserData();
      } else {
        emit(AuthErrorLoginState("Login failed"));
      }
    }).catchError((error) {
      emit(AuthErrorLoginState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isShowLogin = true;

  void loginChangePasswordToShow() {
    isShowLogin = !isShowLogin;
    suffix = isShowLogin ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AuthSignInChangeToShowState());
  }

  IconData suffixx = Icons.visibility_outlined;
  bool isShowSignUp = true;

  void registerChangePasswordToShow() {
    isShowSignUp = !isShowSignUp;
    suffixx = isShowSignUp ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AuthRegisterChangeToShowState());
  }

  void userRegister({required String name, required String num, required String email, required String password}) {
    emit(AuthLoadingRegisterState());
    _authService.register(name: name, num: num, email: email, password: password).then((_) {
      emit(AuthSuccessCreateUserState());
    }).catchError((error) {
      emit(AuthErrorCreateState(error.toString()));
    });
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoadingRestPasswordState());
    await _authService.resetPassword(email).then((_) {
      emit(AuthSuccessRestPasswordState());
    }).catchError((error) {
      emit(AuthErrorRestPasswordState(error.toString()));
    });
  }
}
