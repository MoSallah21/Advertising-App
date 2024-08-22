import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/features/auth/domain/entities/user.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserDataUseCase{
  final AuthRepository repository;

  GetUserDataUseCase(this.repository);

  Future<Either<Failure,Users>> call (String uId) async
  => await repository.getUserData();

}