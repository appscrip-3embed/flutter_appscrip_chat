import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/data.dart';
import 'views/views.dart';

DBWrapper? dbWrapper;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await initialize();
  runApp(const MyApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  if (!kIsWeb) {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgorundHandler);

    // when app is killed
    final initialMessage = await messaging.getInitialMessage();
    IsmChatLog.error('recieved messgae on app killed step1');
    if (initialMessage != null) {
      IsmChatLog.error('recieved messgae on app killed step2');
      LocalNoticeService().cancelAllNotification();
      LocalNoticeService().addNotification(
        '', // Add the  sender user name here
        '', // MessageName
        DateTime.now().millisecondsSinceEpoch + 1 * 1000,
        sound: '',
        channel: 'message',
      );
    }

    // when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      IsmChatLog.error('recieved messgae on app background');
      LocalNoticeService().cancelAllNotification();
      LocalNoticeService().addNotification(
        '', // Add the  sender user name here
        '', // MessageName
        DateTime.now().millisecondsSinceEpoch + 1 * 1000,
        sound: '',
        channel: 'message',
      );
    });
  }
  dbWrapper = await DBWrapper.create();
  await AppConfig.getUserData();
  await Future.wait(
    [
      AppscripChatComponent.initialize(),
      LocalNoticeService().setup(),
    ],
  );
}

/// Call this funcation for get notifcaiton when app killed
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgorundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 745),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => child!,
      child: GetMaterialApp(
        key: const Key('ChatApp'),
        navigatorKey: navigatorKey,
        title: 'Flutter chat',
        locale: const Locale('en', 'US'),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        theme: ThemeData.light(useMaterial3: true)
            .copyWith(primaryColor: AppColors.primaryColorLight),
        // darkTheme: ThemeData.dark(useMaterial3: true)
        //     .copyWith(primaryColor: AppColors.primaryColorDark),
        // darkTheme: ThemeData.dark(useMaterial3: true)
        //     .copyWith(primaryColor: AppColors.primaryColorDark),
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        initialRoute:
            AppConfig.userDetail != null ? ChatList.route : LoginView.route,
        getPages: AppPages.pages,
      ),
    );
  }
}
