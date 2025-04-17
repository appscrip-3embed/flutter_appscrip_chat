import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/data/data.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:chat_component_example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

DBWrapper? dbWrapper;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await initialize();
  runApp(const MyApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbWrapper = await DBWrapper.create();
  await AppConfig.getUserData();
  await LocalNoticeService().setup();
  await AppscripChatComponent.initialize();
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
  Widget build(BuildContext context) => ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 745),
        builder: (_, child) => child!,
        child: GetMaterialApp(
          key: const Key('ChatApp'),
          navigatorKey: navigatorKey,
          locale: const Locale('en', 'US'),
          // localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
