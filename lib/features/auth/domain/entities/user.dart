import 'package:equatable/equatable.dart';

class Users extends Equatable{
  final String? username;
  final String? email;
  final String? num;
  final String? uId;

  Users({required this.username, required this.email, required this.num, required this.uId});
  @override
  List<Object?> get props => [username,email,num,uId];
}