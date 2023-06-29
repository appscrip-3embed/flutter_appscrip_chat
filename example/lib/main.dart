import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/data/database/database.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/views/chat_list.dart';
import 'package:chat_component_example/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

late ObjectBox objectBox;

void main() async {
  await initialize();
  runApp(const MyApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();
  var deviceConfig = Get.put(IsmChatDeviceConfig());
  deviceConfig.init();

  await AppscripChatComponent.initialize();
  await LocalNoticeService().setup();
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
      builder: (_, child) => child!,
      child: GetMaterialApp(
        key: const Key('ChatApp'),
        locale: const Locale('en', 'US'),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
        initialRoute: objectBox.userDetailsBox.getAll().isNotEmpty
            ? ChatList.route
            : LoginView.route,
        getPages: AppPages.pages,
      ),
    );
  }
}
