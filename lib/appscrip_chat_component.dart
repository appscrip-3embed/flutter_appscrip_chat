library appscrip_chat_component;

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/appscrip_chat_component_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
export 'src/app/app.dart';
export 'src/controllers/controllers.dart';
export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/repositories/repositories.dart';
export 'src/res/res.dart';
export 'src/utilities/utilities.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widgets/widgets.dart';

class AppscripChatComponent {
  Future<String?> getPlatformVersion() =>
      ChatComponentPlatform.instance.getPlatformVersion();

  static Future<void> initialize({bool useDatabase = true}) async {
    IsmChatConfig.useDatabase = !kIsWeb && useDatabase;
    Get.put(IsmChatDeviceConfig()).init();

    IsmChatConfig.dbWrapper = await IsmChatDBWrapper.create();

    IsmChatConfig.isInitialized = true;
  }
}
