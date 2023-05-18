
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/widgets.dart';

class IsmChatConversationAction {
  IsmChatConversationAction({
    required this.label,
    required this.onTap,
    this.style,
    this.backgroundColor,
   required this.icon,
   this.borderRadius,
  });

  final String label;
  final void Function(IsmChatConversationModel) onTap;
  final TextStyle? style;
  final Color? backgroundColor;
  final IconData icon;
  final BorderRadius? borderRadius;
}
