// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() =>
      'IsmChatPopItem(label: $label, icon: $icon, color: $color, onTap: $onTap)';

  @override
  bool operator ==(covariant IsmChatPopItem other) {
    if (identical(this, other)) return true;

    return other.label == label && other.icon == icon && other.color == color;
  }

  @override
  int get hashCode =>
      label.hashCode ^ icon.hashCode ^ color.hashCode ^ onTap.hashCode;
}
