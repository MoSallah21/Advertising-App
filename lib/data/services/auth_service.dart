import 'package:adphotos/data/providers/auth_provider.dart';
import 'package:adphotos/data/repositories/user_repository.dart';
import 'package:adphotos/models/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final AuthProvider _authProvider;
  final UserRepository _userRepository;

  AuthService(this._authProvider, this._userRepository);

  Future<User?> signIn({required String email, required String password}) {
    return _authProvider.signIn(email: email, password: password);
  }

  Future<void> signOut() {
    return _authProvider.signOut();
  }

  Future<void> resetPassword(String email) {
    return _authProvider.resetPassword(email);
  }

  Future<void> register({
    required String name,
    required String num,
    required String email,
    required String password,
  }) async {
    User? user = await _authProvider.register(email: email, password: password);
    if (user != null) {
      UsersModel userModel = UsersModel(username: name, email: email, num: num, uId: user.uid);
      await _userRepository.createUser(userModel);
    }
  }

  Future<UsersModel?> getUserData(String uId) {
    return _userRepository.getUserData(uId);
  }
}
