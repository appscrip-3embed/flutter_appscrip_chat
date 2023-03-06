import 'package:chat_component/src/res/config/config_constant.dart';
import 'package:chat_component/src/res/res.dart';

class ChatConfig {
  ChatConfig({
    required this.communicationConfig,
    required this.chatTheme,
  }) {
    ConfigConstants.communicationConfig = communicationConfig;
    ConfigConstants.chatTheme = chatTheme;
  }

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [ChatCommunicationConfig]
  final ChatCommunicationConfig communicationConfig;

  final ChatThemeData chatTheme;
}
