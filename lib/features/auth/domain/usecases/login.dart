import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase{
  final AuthRepository repository;

  LoginUseCase(this.repository);
  Future<Either<Failure,Unit>> call(String email,String password)async{
    return await repository.login(email,password) ;

  }
}