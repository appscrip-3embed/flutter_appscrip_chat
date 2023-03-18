import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MatchString on String {
  bool didMatch(String other) => toLowerCase().contains(other.toLowerCase());
}

extension DateConvertor on int {
  DateTime toDate() => DateTime.fromMillisecondsSinceEpoch(this);

  String toDateString() =>
      DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(this));
}

extension DateFormats on DateTime {
  String toDateString() => DateFormat.jm().format(this);
}

extension ChildWidget on CustomMessageType {
  Widget messageType(ChatMessageModel message) {
    switch (this) {
      case CustomMessageType.text:
        return TextMessage(message);

      case CustomMessageType.reply:
        return ReplyMessage(message);

      case CustomMessageType.forward:
        return ForwardMessage(message);

      case CustomMessageType.image:
        return ImageMessage(message);

      case CustomMessageType.video:
        return VideoMessage(message);

      case CustomMessageType.audio:
        return AudioMessage(message);

      case CustomMessageType.file:
        return FileMessage(message);

      case CustomMessageType.location:
        return LocationMessage(message);

      case CustomMessageType.block:
        return BlockedMessage(message);

      case CustomMessageType.unblock:
        return BlockedMessage(message);

      case CustomMessageType.deletedForMe:
        return DeletedMessage(message);

      case CustomMessageType.deletedForEveryone:
        return DeletedMessage(message);

      case CustomMessageType.date:
        return DateMessage(message);
    }
  }
}
