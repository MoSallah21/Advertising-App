import 'package:adphotos/layout/home/home_screen.dart';
import 'package:adphotos/modules/auth/login_screen.dart';
import 'package:adphotos/shared/bloc/auth/authbloc.dart';
import 'package:adphotos/shared/network/local/remot/cachehelper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/constants/bloc_observer.dart';
import 'shared/constants/constants.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await firebaseMessagingBackgroundHandler;
  Bloc.observer = MyBlocObserver();
  uId = CacheHelper.getData(key:'uId');
  await Firebase.initializeApp();
  Widget widget;
  if (uId != null) {
    widget = HomeScreen();
  } else
    widget = LoginScreen();
  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key,required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>AuthBloc()..getUserData(),
        ),
        BlocProvider(
          create: (BuildContext context) =>AuthBloc(),
        ),
      ], child: MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(
        color: Colors.grey,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2,
      ),),
      debugShowCheckedModeBanner: false,
      home:startWidget,
    ),
    );
  }
}

