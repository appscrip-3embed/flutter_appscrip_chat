import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/widgets.dart';

class IsmChatConversationAction {
  IsmChatConversationAction(
      {this.label,
      required this.onTap,
      required this.icon,
      this.decoration,
      this.labelStyle});

  final Decoration? decoration;
  final Widget icon;
  final String? label;
  final TextStyle? labelStyle;
  final void Function(IsmChatConversationModel) onTap;
}
