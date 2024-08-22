import 'dart:convert';
import 'package:adphotos/core/errors/exception.dart';
import 'package:adphotos/core/network/local/remot/cachehelper.dart';
import 'package:adphotos/features/auth/data/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource{
  Future<UserModel> getCachedUserData();
  Future<Unit>cacheUserData(UserModel userModels);
  Future<Unit>cacheUserUid(String uId);
}
const String CACHED_USER="CACHED_USER";
class AuthLocalDatasourceImpl implements AuthLocalDatasource{
 final SharedPreferences sharedPreferences;
 AuthLocalDatasourceImpl({required this.sharedPreferences});
  @override
  Future<Unit> cacheUserData(UserModel userModel) async {
      String userJson = json.encode(userModel.toJson());
      await sharedPreferences.setString(CACHED_USER, userJson);
      return Future.value(unit);
  }
  @override
  Future<UserModel> getCachedUserData() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
        final Map<String, dynamic> jsonData = json.decode(jsonString);
        return UserModel.fromJson(jsonData);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> cacheUserUid(String uId) {
    CacheHelper.saveData(key: 'UID', value:uId);
    return Future.value(unit);

  }}