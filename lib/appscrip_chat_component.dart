library appscrip_chat_component;

import 'package:appscrip_chat_component/appscrip_chat_component_platform_interface.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:appscrip_chat_component/src/data/data.dart';

export 'src/app/app.dart';
export 'src/controllers/controllers.dart';
export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/res/res.dart';
export 'src/utilities/utilities.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widgets/widgets.dart';

class AppscripChatComponent {
  Future<String?> getPlatformVersion() =>
      ChatComponentPlatform.instance.getPlatformVersion();

  static Future<void> initialize() async {
    ChatConstants.objectBox = await ChatObjectBox.create();
    ChatConstants.isInitialized = true;
  }
}
