import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatBottomSheetAttachmentModel {
  const IsmChatBottomSheetAttachmentModel({
    required this.label,
    required this.backgroundColor,
    required this.icon,
    required this.attachmentType,
  });

  final String label;
  final Color backgroundColor;
  final IconData icon;
  final IsmChatAttachmentType attachmentType;
}
