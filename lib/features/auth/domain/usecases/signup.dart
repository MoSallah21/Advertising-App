import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase{
  final AuthRepository repository;

  SignupUseCase(this.repository);
  Future<Either<Failure,Unit>> call(String username, String email, String num, String password)async{
    return await repository.signup(username,email,num,password);
  }
}