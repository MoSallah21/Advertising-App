import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure,Unit>>signup(String username, String email, String num, String password);

  Future<Either<Failure,Unit>>login(String email,String password);

  Future<Either<Failure, Users>> getUserData();

  Future<Either<Failure,Unit>> forgetPassword(String email);


}