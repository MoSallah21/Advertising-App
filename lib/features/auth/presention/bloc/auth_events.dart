part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class LoginEvent extends AuthEvent{
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email,password];

}

class SignupEvent extends AuthEvent{
   final  String username;
   final  String email;
   final  String num;
   final  String password;

  SignupEvent({required this.username, required this.email, required this.num, required this.password});

   @override
   List<Object?> get props => [username,email,num,password];


}

class ForgetPasswordEvent extends AuthEvent{
  final String email;

  ForgetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];

}

class GetUserDataEvent extends AuthEvent {
  final String uId;

  GetUserDataEvent({required this.uId});

  @override
  List<Object?> get props => [uId];
}



