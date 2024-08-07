import 'package:adphotos/layout/home/home_screen.dart';
import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:adphotos/shared/bloc/auth/authbloc.dart';
import 'package:adphotos/shared/network/local/remot/cachehelper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/bloc/app/appbloc.dart';
import 'shared/constants/bloc_observer.dart';
import 'shared/constants/constants.dart';
import 'package:adphotos/data/repositories/ad_repository.dart';
import 'package:adphotos/data/providers/auth_provider.dart';
import 'package:adphotos/data/repositories/user_repository.dart';
import 'package:adphotos/data/services/auth_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await firebaseMessagingBackgroundHandler;
  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key: 'uId');
  await Firebase.initializeApp();

  // Create instances of repositories and services
  final adRepository = AdRepository();
  final authProvider = AuthProvider();
  final userRepository = UserRepository();
  final authService = AuthService(authProvider, userRepository);

  Widget widget;
  if (uId != null) {
    widget = HomeScreen();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
    adRepository: adRepository,
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  final AdRepository adRepository;
  final AuthService authService;

  const MyApp({
    super.key,
    required this.startWidget,
    required this.adRepository,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppBloc(adRepository),
        ),
        BlocProvider(
          create: (BuildContext context) => AuthBloc(authService)..getUserData(),
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
