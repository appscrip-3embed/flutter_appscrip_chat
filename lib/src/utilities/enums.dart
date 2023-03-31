import 'package:any_link_preview/any_link_preview.dart';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';

enum IsmChatMessageType {
  normal(0),
  forward(1),
  reply(2),
  admin(3);

  const IsmChatMessageType(this.value);

  factory IsmChatMessageType.fromValue(int value) {
    switch (value) {
      case 0:
        return IsmChatMessageType.normal;
      case 1:
        return IsmChatMessageType.forward;
      case 2:
        return IsmChatMessageType.reply;
      case 3:
        return IsmChatMessageType.admin;
      default:
        return IsmChatMessageType.normal;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum IsmChatCustomMessageType {
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

  const IsmChatCustomMessageType(this.value);

  factory IsmChatCustomMessageType.fromValue(int val) {
    switch (val) {
      case 1:
        return IsmChatCustomMessageType.text;
      case 2:
        return IsmChatCustomMessageType.reply;
      case 3:
        return IsmChatCustomMessageType.forward;
      case 4:
        return IsmChatCustomMessageType.image;
      case 5:
        return IsmChatCustomMessageType.video;
      case 6:
        return IsmChatCustomMessageType.audio;
      case 7:
        return IsmChatCustomMessageType.file;
      case 8:
        return IsmChatCustomMessageType.location;
      case 9:
        return IsmChatCustomMessageType.block;
      case 10:
        return IsmChatCustomMessageType.unblock;
      case 11:
        return IsmChatCustomMessageType.deletedForMe;
      case 12:
        return IsmChatCustomMessageType.deletedForEveryone;
      case 13:
        return IsmChatCustomMessageType.link;
      case 100:
        return IsmChatCustomMessageType.date;
      default:
        return IsmChatCustomMessageType.text;
    }
  }

  factory IsmChatCustomMessageType.fromString(String value) {
    const map = <String, IsmChatCustomMessageType>{
      'text': IsmChatCustomMessageType.text,
      'file': IsmChatCustomMessageType.file,
      'replyText': IsmChatCustomMessageType.reply,
      'reply': IsmChatCustomMessageType.reply,
      'image': IsmChatCustomMessageType.image,
      'audio': IsmChatCustomMessageType.audio,
      'video': IsmChatCustomMessageType.video,
      'location': IsmChatCustomMessageType.location,
      'block': IsmChatCustomMessageType.block,
      'unblock': IsmChatCustomMessageType.unblock,
    };

    var type = value.split('.').last;
    return map[type] ?? IsmChatCustomMessageType.text;
  }

  factory IsmChatCustomMessageType.fromMap(dynamic value) {
    if (value.runtimeType != int && value.runtimeType != String) {
      return IsmChatCustomMessageType.text;
    }
    if (value.runtimeType == int) {
      return IsmChatCustomMessageType.fromValue(value as int);
    } else {
      return IsmChatCustomMessageType.fromString(value as String);
    }
  }

  factory IsmChatCustomMessageType.withBody(String body) {
    if (body.isEmpty) {
      return IsmChatCustomMessageType.text;
    }
    if (body.toLowerCase().contains('map')) {
      return IsmChatCustomMessageType.location;
    }
    if (IsmChatConstants.imageExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return IsmChatCustomMessageType.image;
    }
    if (IsmChatConstants.videoExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return IsmChatCustomMessageType.video;
    }
    if (IsmChatConstants.audioExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return IsmChatCustomMessageType.audio;
    }
    if (IsmChatConstants.fileExtensions
        .any((e) => body.toLowerCase().endsWith(e.toLowerCase()))) {
      return IsmChatCustomMessageType.file;
    }
    if (AnyLinkPreview.isValidLink(body) ||
        body.toLowerCase().contains('.com')) {
      return IsmChatCustomMessageType.link;
    }
    return IsmChatCustomMessageType.text;
  }

  static IsmChatCustomMessageType? fromAction(String value) {
    var action = IsmChatActionEvents.fromName(value);

    switch (action) {
      case IsmChatActionEvents.typingEvent:
        return null;
      case IsmChatActionEvents.conversationCreated:
        return null;
      case IsmChatActionEvents.messageDelivered:
        return null;
      case IsmChatActionEvents.messageRead:
        return null;
      case IsmChatActionEvents.messagesDeleteForAll:
        return null;
      case IsmChatActionEvents.multipleMessagesRead:
        return null;
      case IsmChatActionEvents.clearConversation:
        return null;
      case IsmChatActionEvents.userBlock:
        return IsmChatCustomMessageType.block;
      case IsmChatActionEvents.userBlockConversation:
        return IsmChatCustomMessageType.block;
      case IsmChatActionEvents.userUnblock:
        return IsmChatCustomMessageType.unblock;
      case IsmChatActionEvents.userUnblockConversation:
        return IsmChatCustomMessageType.unblock;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum IsmChatConnectionState {
  connected,
  disconnected,
  connecting,
  subscribed,
  unsubscribed;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum IsmChatMessageStatus {
  pending(0),
  sent(1),
  delivered(2),
  read(3);

  const IsmChatMessageStatus(this.value);

  final int value;
}

enum IsmChatConversationType {
  private(0),
  public(1),
  open(2);

  const IsmChatConversationType(this.value);

  factory IsmChatConversationType.fromValue(int value) {
    switch (value) {
      case 0:
        return IsmChatConversationType.private;
      case 1:
        return IsmChatConversationType.public;
      case 2:
        return IsmChatConversationType.open;
      default:
        return IsmChatConversationType.public;
    }
  }

  final int value;

  @override
  String toString() =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
}

enum IsmChatAttachmentType {
  image(0),
  video(1),
  audio(2),
  file(3);

  const IsmChatAttachmentType(this.value);

  factory IsmChatAttachmentType.fromMap(int value) {
    switch (value) {
      case 0:
        return IsmChatAttachmentType.image;
      case 1:
        return IsmChatAttachmentType.video;
      case 2:
        return IsmChatAttachmentType.audio;
      case 3:
        return IsmChatAttachmentType.file;
      default:
        return IsmChatAttachmentType.image;
    }
  }

  final int value;
}

enum IsmChatActionEvents {
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

  factory IsmChatActionEvents.fromName(String name) {
    switch (name) {
      case 'typingEvent':
        return IsmChatActionEvents.typingEvent;
      case 'conversationCreated':
        return IsmChatActionEvents.conversationCreated;
      case 'messageDelivered':
        return IsmChatActionEvents.messageDelivered;
      case 'messageRead':
        return IsmChatActionEvents.messageRead;
      case 'messagesDeleteForAll':
        return IsmChatActionEvents.messagesDeleteForAll;
      case 'multipleMessagesRead':
        return IsmChatActionEvents.multipleMessagesRead;
      case 'userBlock':
        return IsmChatActionEvents.userBlock;
      case 'userBlockConversation':
        return IsmChatActionEvents.userBlockConversation;
      case 'userUnblock':
        return IsmChatActionEvents.userUnblock;
      case 'userUnblockConversation':
        return IsmChatActionEvents.userUnblockConversation;
      case 'clearConversation':
        return IsmChatActionEvents.clearConversation;
      default:
        return IsmChatActionEvents.typingEvent;
    }
  }
}
