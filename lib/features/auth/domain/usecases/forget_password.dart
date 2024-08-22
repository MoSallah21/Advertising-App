import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgetPasswordUseCase{
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);
  Future<Either<Failure,Unit>> call(String email)async{
    return await repository.forgetPassword(email);
  }
}