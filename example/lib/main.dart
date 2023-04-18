import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/data/database/database.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/views/chat_list.dart';
import 'package:chat_component_example/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _chatComponentPlugin = AppscripChatComponent();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _chatComponentPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
