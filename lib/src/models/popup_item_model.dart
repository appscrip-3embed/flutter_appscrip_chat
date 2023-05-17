import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/widgets.dart';

class IsmChatPopItem {
  IsmChatPopItem({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color? color;
  final void Function(IsmChatConversationModel) onTap;
}
