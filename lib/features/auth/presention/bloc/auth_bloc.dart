import 'package:adphotos/core/network/local/remot/cachehelper.dart';
import 'package:adphotos/features/auth/domain/entities/user.dart';
import 'package:adphotos/features/auth/domain/usecases/forget_password.dart';
import 'package:adphotos/features/auth/domain/usecases/get_user_data.dart';
import 'package:adphotos/features/auth/domain/usecases/login.dart';
import 'package:adphotos/features/auth/domain/usecases/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adphotos/core/errors/failures.dart';
import 'package:adphotos/core/strings/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
part 'auth_events.dart';
part 'auth_status.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  final LoginUseCase login;
  final SignupUseCase signup;
  final ForgetPasswordUseCase forgetPassword;
  final GetUserDataUseCase getUserData;


  AuthBloc({required this.login,required this.signup,required this.forgetPassword,required this.getUserData}):super(AuthInitState()) {
    on<AuthEvent>((event,emit)async{
      if(event is LoginEvent){
        emit(AuthLoadingLoginState());
        final failureOrSuccess=await login.call(event.email,event.password);
        emit(_login(failureOrSuccess));
      }
      else if(event is SignupEvent){
        emit(AuthLoadingRegisterState());
        final failureOrPosts =await signup.call(event.username,event.email,event.num,event.password);
        emit(_signup(failureOrPosts));
      }

      else if(event is ForgetPasswordEvent){
        emit(AuthLoadingForgetPasswordState());
        final failureOrPosts =await forgetPassword.call(event.email);
        emit(_forgetPassword(failureOrPosts));
      }

      else if(event is GetUserDataEvent){
        emit(AuthGetUserLoadingState());
        final failureOrPosts =await getUserData.call(CacheHelper.getData(key: "UID"));
        emit(_getUserData(failureOrPosts));
      }

    });

  }
}
AuthState _login(Either<Failure, Unit> either) {
  return either.fold(
        (failure) => AuthErrorLoginState(message: _mapFailureToMessage(failure)),
        (_) => AuthSuccessLoginState(),
  );
}

AuthState _signup(Either<Failure,Unit> either){
  return either.fold(
        (failure)=>AuthErrorRegisterState(message: _mapFailureToMessage(failure)),
        (_)=> AuthSuccessRegisterState(),
  );
}

AuthState _forgetPassword(Either<Failure,Unit> either){
  return either.fold(
        (failure)=>AuthErrorForgetPasswordState(message: _mapFailureToMessage(failure)),
        (_)=> AuthSuccessForgetPasswordState(),
  );
}

AuthState _getUserData(Either<Failure,Users> either){
  return either.fold(
        (failure)=>AuthGetUserErrorState(message: _mapFailureToMessage(failure)),
        (userData)=> AuthGetUserSuccessState(userData: userData),
  );
}

String _mapFailureToMessage(Failure failure){
  switch (failure.runtimeType){
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case OffLineFailure:
      return OFF_LINE_FAILURE_MESSAGE;
    default: return "Unexpected error, please try again later";
  }
}