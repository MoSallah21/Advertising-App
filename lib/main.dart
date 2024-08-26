import 'package:adphotos/core/network/local/remot/cachehelper.dart';
import 'package:adphotos/features/Ads/presention/bloc/ad_bloc.dart';
import 'package:adphotos/features/auth/presention/pages/login_page.dart';
import 'package:adphotos/layout/home/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:adphotos/core/bloc_observer.dart';
import 'core/strings/constants.dart';
import 'features/auth/presention/bloc/auth_bloc.dart';
import 'injection_container.dart'as di;

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


  Widget startWidget;

  if (uId != null) {
    startWidget = HomePage();
  }
  else {
    startWidget = LoginPage();
  }

  runApp(MyApp(
    startWidget: startWidget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({
    Key? key,
    required this.startWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>di.sl<AdBloc>()..add(GetAllAdsEvent(catName: ''))),
        BlocProvider(create: (_)=>di.sl<AuthBloc>()..add(GetUserDataEvent(uId: uId))),
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
