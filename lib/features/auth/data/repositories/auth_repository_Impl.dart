import 'package:adphotos/core/errors/exception.dart';
import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/core/network/local/remot/network_info.dart';
import 'package:adphotos/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:adphotos/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:adphotos/features/auth/domain/entities/user.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
typedef Future<Unit> SignupOrLoginOrForget();


class AuthRepositoryImpl implements AuthRepository {
   NetworkInfo networkInfo;
   AuthRemoteDatasource remoteDatasource;
   AuthLocalDatasource localDatasource;


   AuthRepositoryImpl({required this.networkInfo,required this.remoteDatasource,required this.localDatasource});

   @override
  Future<Either<Failure, Unit>> signup(String username, String email, String num, String password)async {
    return await _getMessage(() =>
        remoteDatasource.signup( username,  email,  num,  password));

  }

  @override
  Future<Either<Failure, Unit>> forgetPassword(String email)async {
    return await _getMessage(() =>
        remoteDatasource.forgetPassword(email));
  }

   @override
   Future<Either<Failure, Users>> getUserData()async {
     if (await networkInfo.isConnected) {
       try {
         final remoteUser = await remoteDatasource.getUserData();
         localDatasource.cacheUserData(remoteUser);
         return Right(remoteUser);
       } on ServerException {
         return Left(ServerFailure());
       }
     } else {
       try {
         final localPosts = await localDatasource.getCachedUserData();
         return Right(localPosts);
       } on EmptyCacheException {
         return Left(EmptyCacheFailure());
       }
     }
   }


  @override
  Future<Either<Failure, Unit>> login(String email, String password)async {
    return await _getMessage(() =>
        remoteDatasource.login(email,password));
  }
  Future<Either<Failure, Unit>> _getMessage(
      SignupOrLoginOrForget signupOrLoginOrForget) async {
    if (await networkInfo.isConnected) {
      try {
        await signupOrLoginOrForget();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
      on FirebaseAuthException catch (e) {
        return Left(_mapFirebaseAuthExceptionToFailure(e));
      }
    } else {
      return Left(OffLineFailure());
    }
  }

   Failure _mapFirebaseAuthExceptionToFailure(FirebaseAuthException e) {
     switch (e.code) {
       case 'user-not-found':
         return FirebaseFailure();
       case 'wrong-password':
         return FirebaseFailure();
       case 'invalid-email':
         return FirebaseFailure();
       default:
         return FirebaseFailure();
     }
   }
}





