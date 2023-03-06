library chat_component;

import 'package:chat_component/chat_component_platform_interface.dart';

export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/res/res.dart';
export 'src/utilities/utilities.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widgets/widgets.dart';

class ChatComponent {
  Future<String?> getPlatformVersion() =>
      ChatComponentPlatform.instance.getPlatformVersion();
}
