import 'dart:async';

import 'package:app_settings/app_settings.dart';
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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgorundHandler);
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      final PushNotificationService notificationService =
          PushNotificationService();
      notificationService.requestNotificationService();

      notificationService.initialize();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // if ([AppLifecycleState.detached, AppLifecycleState.inactive]
    //     .contains(state)) return;
    if (AppLifecycleState.paused == state) {
      IsmChatLog.error('app in backgorund');
    }
    if (AppLifecycleState.detached == state) {
      IsmChatLog.error('app in killed');
    }
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

class PushNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationService() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (![AuthorizationStatus.authorized, AuthorizationStatus.provisional]
        .contains(settings.authorizationStatus)) {
      AppSettings.openAppSettings();
    }
  }

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      IsmChatLog.error('Got a message whilst in the foreground!');
      IsmChatLog.error('Message data: ${message.data}');

      if (message.notification != null) {
        IsmChatLog.error(
            'Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await messaging.getToken();
    IsmChatLog.error('Token: $token');
    return token;
  }
}
