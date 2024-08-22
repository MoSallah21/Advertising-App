import 'package:adphotos/features/auth/domain/entities/user.dart';

class UserModel extends Users {
  UserModel(
      {
        required super.username,
        required super.email,
        required super.num,
        required super.uId,
      });



  factory UserModel.fromJson(Map<String, dynamic>? json) {
  return  UserModel(
    username : json!['username'],
    email : json['email'],
    num : json['num'],
    uId : json['uId'],);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'num':num,
      'uId': uId,
    };
  }

}
