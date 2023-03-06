library chat_component;

export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/res/res.dart';
export 'src/utilities/utilities.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widgets/widgets.dart';

import 'chat_component_platform_interface.dart';

class ChatComponent {
  Future<String?> getPlatformVersion() {
    return ChatComponentPlatform.instance.getPlatformVersion();
  }
}
