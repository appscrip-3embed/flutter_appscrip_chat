import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatConversationProperties {
  const IsmChatConversationProperties({
    this.onChatTap,
    this.onForwardTap,
    this.onCreateTap,
    this.useCallbackOnForward = false,
    this.useCallbackOnCreate = false,
    this.cardBuilder,
    this.cardElementBuilders,
  });

  final ConversationVoidCallback? onChatTap;
  final ConversationVoidCallback? onForwardTap;
  final ConversationVoidCallback? onCreateTap;
  final bool useCallbackOnForward;
  final bool useCallbackOnCreate;
  final ConversationCardCallback? cardBuilder;
  final IsmChatCardProperties? cardElementBuilders;
}
