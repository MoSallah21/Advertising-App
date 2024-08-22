part of 'auth_bloc.dart';

abstract class AuthState{}

class AuthInitState extends AuthState{}

//login
class AuthSuccessLoginState extends AuthState{
}

class AuthErrorLoginState extends AuthState{
  final String message;

  AuthErrorLoginState({required this.message});
}

class AuthLoadingLoginState extends AuthState{}

//get user data
class AuthGetUserLoadingState extends AuthState{}

class AuthGetUserSuccessState extends AuthState{
  final Users userData;

  AuthGetUserSuccessState({required this.userData});
}

class AuthGetUserErrorState extends AuthState{
  final String message;
  AuthGetUserErrorState({required this.message});
}

// register

class AuthLoadingRegisterState extends AuthState{}

class AuthSuccessRegisterState extends AuthState{}

class AuthErrorRegisterState extends AuthState{
  final String message;
  AuthErrorRegisterState({required this.message});
}


class AuthSignInChangeToShowState extends AuthState{}

class AuthRegisterChangeToShowState extends AuthState{}

//rest password
class AuthLoadingForgetPasswordState extends AuthState{}

class AuthSuccessForgetPasswordState extends AuthState{}

class AuthErrorForgetPasswordState extends AuthState{

  String message;

  AuthErrorForgetPasswordState({required this.message});
}