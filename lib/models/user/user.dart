class UsersModel {
  String? username;
  String? email;
  String? num;
  String? uId;
  UsersModel({
   required this.username,
   required this.email,
   required this.num,
   required this.uId,
  });
  UsersModel.fromJson(Map<String, dynamic>? json) {
    username = json!['username'];
    email = json['email'];
    num = json['num'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'num':num,
      'uId': uId,
    };
  }
}
