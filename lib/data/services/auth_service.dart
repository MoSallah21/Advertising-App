import 'package:adphotos/data/repositories/user_repository.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService( this._authRepository);

  Future<User?> signIn({required String email, required String password}) {
    return _authRepository.signIn(email: email, password: password);
  }

  Future<void> signOut() {
    return _authRepository.signOut();
  }

  Future<void> resetPassword(String email) {
    return _authRepository.resetPassword(email);
  }

  Future<void> register({
    required String name,
    required String num,
    required String email,
    required String password,
  }) async {
    User? user = await _authRepository.register(email: email, password: password);
    if (user != null) {
      UsersModel userModel = UsersModel(username: name, email: email, num: num, uId: user.uid);
      await _authRepository.createUser(userModel);
    }
  }

  Future<UsersModel?> getUserData(String uId) {
    return _authRepository.getUserData(uId);
  }
}
