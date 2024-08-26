import 'package:adphotos/core/network/local/remot/network_info.dart';
import 'package:adphotos/features/ads/data/datasource/local/ad_local_datasource.dart';
import 'package:adphotos/features/ads/data/datasource/remote/ad_remote_datasource.dart';
import 'package:adphotos/features/ads/data/repositories/ad_repository_Impl.dart';
import 'package:adphotos/features/ads/domain/repositories/ad_repository.dart';
import 'package:adphotos/features/ads/domain/usecases/auto_delete_ad.dart';
import 'package:adphotos/features/ads/domain/usecases/get_all_ads.dart';
import 'package:adphotos/features/ads/presention/bloc/ad_bloc.dart';
import 'package:adphotos/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:adphotos/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:adphotos/features/auth/data/repositories/auth_repository_Impl.dart';
import 'package:adphotos/features/auth/domain/repositories/auth_repository.dart';
import 'package:adphotos/features/auth/domain/usecases/forget_password.dart';
import 'package:adphotos/features/auth/domain/usecases/get_user_data.dart';
import 'package:adphotos/features/auth/domain/usecases/login.dart';
import 'package:adphotos/features/auth/domain/usecases/signup.dart';
import 'package:adphotos/features/auth/presention/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
final sl=GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    internetConnectionChecker: sl(),
  ));
  print('NetworkInfo registered');

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  print('SharedPreferences registered');

  sl.registerLazySingleton(() => http.Client());
  print('http.Client registered');

  sl.registerLazySingleton(() => InternetConnectionChecker());
  print('InternetConnectionChecker registered');

  // DataSources
  sl.registerLazySingleton<AdRemoteDatasource>(() => AdRemoteDatasourceImpl());
  print('AdRemoteDatasource registered');

  sl.registerLazySingleton<AdLocalDatasource>(() => AdLocalDatasourceImpl(
    sharedPreferences: sl(),
  ));
  print('AdLocalDatasource registered');

  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
  print('AuthRemoteDatasource registered');

  sl.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasourceImpl(
    sharedPreferences: sl(),
  ));
  print('AdLocalDatasource registered');

  // Repository
  sl.registerLazySingleton<AdRepository>(() => AdRepositoryImpl(
    remoteDatasource: sl(),
    localDatasource: sl(),
    networkInfo: sl(),
  ));
  print('AdRepository registered');

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    remoteDatasource: sl(),
    localDatasource: sl(),
    networkInfo: sl(),
  ));
  print('AuthRepositoryImpl registered');

  // UseCases
  sl.registerLazySingleton(() => GetAllAdsUseCase(sl()));
  print('GetAllAdsUseCase registered');

  sl.registerLazySingleton(() => AutoDeleteAdUseCase(sl()));
  print('AutoDeleteAdUseCase registered');

  // sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  // print('DeletePostUseCase registered');

  sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
  print('GetUserDataUseCase registered');

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  print('LoginUseCase registered');

  sl.registerLazySingleton(() => SignupUseCase(sl()));
  print('SignupUseCase registered');

  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  print('SignupUseCase registered');

  // Bloc
  sl.registerFactory(() => AdBloc(getAllAds: sl()));
  print('PostsBloc registered');

  sl.registerFactory(() => AuthBloc(
      login:sl(),
      signup:sl(),
      forgetPassword:sl(),
      getUserData:sl()

  ));
  print('AddDeleteUpdatePostsBloc registered');
}
