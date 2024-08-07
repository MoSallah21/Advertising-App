abstract class AuthState{}

class AuthInitState extends AuthState{}

//sign in
class AuthSuccessLoginState extends AuthState{
  final String uId;

  AuthSuccessLoginState(this.uId);
}

class AuthErrorLoginState extends AuthState{
  final String error;

  AuthErrorLoginState(this.error);
}

class AuthLoadingLoginState extends AuthState{}

//get user data
class AuthGetUserLoadingState extends AuthState{}

class AuthGetUserSuccessState extends AuthState{}

class AuthGetUserErrorState extends AuthState{
  final String error;
  AuthGetUserErrorState(this.error);
}

// register

class AuthLoadingRegisterState extends AuthState{}

class AuthSuccessRegisterState extends AuthState{}

class AuthErrorRegisterState extends AuthState{
  final String error;
  AuthErrorRegisterState(this.error);
}

class AuthSuccessCreateUserState extends AuthState{}

class AuthErrorCreateState extends AuthState{
  final String error;
  AuthErrorCreateState(this.error);
}

class AuthSignInChangeToShowState extends AuthState{}

class AuthRegisterChangeToShowState extends AuthState{}

//rest password
class AuthLoadingRestPasswordState extends AuthState{}

class AuthSuccessRestPasswordState extends AuthState{}

class AuthErrorRestPasswordState extends AuthState{

  String error;

  AuthErrorRestPasswordState(this.error);
}