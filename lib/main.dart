import 'package:adphotos/layout/home/home_screen.dart';
import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:adphotos/data/repositories/ad_repository.dart';
import 'package:adphotos/data/repositories/user_repository.dart';
import 'package:adphotos/data/services/auth_service.dart';
import 'package:adphotos/data/services/ad_service.dart';
import 'package:adphotos/shared/constants/bloc_observer.dart';
import 'package:adphotos/shared/constants/constants.dart';

import 'shared/bloc/app/appbloc.dart';
import 'shared/bloc/auth/authbloc.dart';
import 'shared/network/local/remot/cachehelper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await firebaseMessagingBackgroundHandler;

  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key: 'uId');

  // Create instances of repositories and services
  final adRepository = AdRepository();
  final adService = AdService(adRepository);

  final authRepository = AuthRepository();
  final authService = AuthService(authRepository);

  Widget startWidget;

  if (uId != null) {
    startWidget = HomeScreen();
  } else {
    startWidget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: startWidget,
    adService: adService,
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final AdService adService;
  final AuthService authService;

  const MyApp({
    Key? key,
    required this.startWidget,
    required this.adService,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(adService),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authService)..getUserData(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.grey,
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 2,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: startWidget,
      ),
    );
  }
}
