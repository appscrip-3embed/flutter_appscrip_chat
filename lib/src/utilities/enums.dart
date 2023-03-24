import 'package:any_link_preview/any_link_preview.dart';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';

enum MessageType {
  normal(0),
  forward(1),
  reply(2),
  admin(3);

  const MessageType(this.value);

  factory MessageType.fromValue(int value) {
    switch (value) {
      case 0:
        return MessageType.normal;
      case 1:
        return MessageType.forward;
      case 2:
        return MessageType.reply;
      case 3:
        return MessageType.admin;
      default:
        return MessageType.normal;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum CustomMessageType {
  text(1),
  reply(2),
  forward(3),
  image(4),
  video(5),
  audio(6),
  file(7),
  location(8),
  block(9),
  unblock(10),
  deletedForMe(11),
  deletedForEveryone(12),
  link(13),
  date(100);

  const CustomMessageType(this.value);

  factory CustomMessageType.fromValue(int val) {
    switch (val) {
      case 1:
        return CustomMessageType.text;
      case 2:
        return CustomMessageType.reply;
      case 3:
        return CustomMessageType.forward;
      case 4:
        return CustomMessageType.image;
      case 5:
        return CustomMessageType.video;
      case 6:
        return CustomMessageType.audio;
      case 7:
        return CustomMessageType.file;
      case 8:
        return CustomMessageType.location;
      case 9:
        return CustomMessageType.block;
      case 10:
        return CustomMessageType.unblock;
      case 11:
        return CustomMessageType.deletedForMe;
      case 12:
        return CustomMessageType.deletedForEveryone;
      case 13:
        return CustomMessageType.link;
      case 100:
        return CustomMessageType.date;
      default:
        return CustomMessageType.text;
    }
  }

  factory CustomMessageType.fromString(String value) {
    const map = <String, CustomMessageType>{
      'text': CustomMessageType.text,
      'file': CustomMessageType.file,
      'replyText': CustomMessageType.reply,
      'reply': CustomMessageType.reply,
      'image': CustomMessageType.image,
      'voice': CustomMessageType.audio,
      'video': CustomMessageType.video,
      'location': CustomMessageType.location,
      'block': CustomMessageType.block,
      'unblock': CustomMessageType.unblock,
    };

    var type = value.split('.').last;
    return map[type] ?? CustomMessageType.text;
  }

  factory CustomMessageType.fromMap(dynamic value) {
    if (value.runtimeType != int && value.runtimeType != String) {
      return CustomMessageType.text;
    }
    if (value.runtimeType == int) {
      return CustomMessageType.fromValue(value as int);
    } else {
      return CustomMessageType.fromString(value as String);
    }
  }

  factory CustomMessageType.withBody(String body) {
    if (body.isEmpty) {
      return CustomMessageType.text;
    }
    if (body.toLowerCase().contains('map')) {
      return CustomMessageType.location;
    }
    if (IsmChatConstants.imageExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return CustomMessageType.image;
    }
    if (IsmChatConstants.videoExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return CustomMessageType.video;
    }
    if (IsmChatConstants.audioExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return CustomMessageType.audio;
    }
    if (IsmChatConstants.fileExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return CustomMessageType.file;
    }
    if (AnyLinkPreview.isValidLink(body) ||
        body.toLowerCase().contains('.com')) {
      return CustomMessageType.link;
    }
    return CustomMessageType.text;
  }

  static CustomMessageType? fromAction(String value) {
    var action = ActionEvents.fromName(value);

    switch (action) {
      case ActionEvents.typingEvent:
        return null;
      case ActionEvents.conversationCreated:
        return null;
      case ActionEvents.messageDelivered:
        return null;
      case ActionEvents.messageRead:
        return null;
      case ActionEvents.messagesDeleteForAll:
        return null;
      case ActionEvents.multipleMessagesRead:
        return null;
      case ActionEvents.clearConversation:
        return null;
      case ActionEvents.userBlock:
        return CustomMessageType.block;
      case ActionEvents.userBlockConversation:
        return CustomMessageType.block;
      case ActionEvents.userUnblock:
        return CustomMessageType.unblock;
      case ActionEvents.userUnblockConversation:
        return CustomMessageType.unblock;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum ChatConnectionState {
  connected,
  disconnected,
  connecting,
  subscribed,
  unsubscribed;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum MessageStatus {
  pending(0),
  sent(1),
  delivered(2),
  read(3);

  const MessageStatus(this.value);

  final int value;
}

enum ConversationType {
  private(0),
  public(1),
  open(2);

  const ConversationType(this.value);

  factory ConversationType.fromValue(int value) {
    switch (value) {
      case 0:
        return ConversationType.private;
      case 1:
        return ConversationType.public;
      case 2:
        return ConversationType.open;
      default:
        return ConversationType.public;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum AttachmentType {
  image(0),
  video(1),
  audio(2),
  file(3);

  const AttachmentType(this.value);

  factory AttachmentType.fromMap(int value) {
    switch (value) {
      case 0:
        return AttachmentType.image;
      case 1:
        return AttachmentType.video;
      case 2:
        return AttachmentType.audio;
      case 3:
        return AttachmentType.file;
      default:
        return AttachmentType.image;
    }
  }

  final int value;
}

enum ActionEvents {
  typingEvent,
  conversationCreated,
  messageDelivered,
  messageRead,
  messagesDeleteForAll,
  multipleMessagesRead,
  userBlock,
  userBlockConversation,
  userUnblock,
  userUnblockConversation,
  clearConversation;

  factory ActionEvents.fromName(String name) {
    switch (name) {
      case 'typingEvent':
        return ActionEvents.typingEvent;
      case 'conversationCreated':
        return ActionEvents.conversationCreated;
      case 'messageDelivered':
        return ActionEvents.messageDelivered;
      case 'messageRead':
        return ActionEvents.messageRead;
      case 'messagesDeleteForAll':
        return ActionEvents.messagesDeleteForAll;
      case 'multipleMessagesRead':
        return ActionEvents.multipleMessagesRead;
      case 'userBlock':
        return ActionEvents.userBlock;
      case 'userBlockConversation':
        return ActionEvents.userBlockConversation;
      case 'userUnblock':
        return ActionEvents.userUnblock;
      case 'userUnblockConversation':
        return ActionEvents.userUnblockConversation;
      case 'clearConversation':
        return ActionEvents.clearConversation;
      default:
        return ActionEvents.typingEvent;
    }
  }
}
