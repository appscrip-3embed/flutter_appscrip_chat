import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/widgets.dart';

class IsmChatConversationAction {
  IsmChatConversationAction({
    required this.onTap,
    this.labelStyle,
    this.label,
    this.decoration,
    required this.icon,
  });

  final Decoration? decoration;
  final Widget icon;
  final String? label;
  final TextStyle? labelStyle;
  final void Function(IsmChatConversationModel) onTap;
}
