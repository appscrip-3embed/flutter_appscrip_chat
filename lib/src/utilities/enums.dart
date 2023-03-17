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
  image(3),
  video(4),
  audio(5),
  file(6),
  location(7),
  block(8),
  unblock(9),
  deletedForMe(10),
  deletedForEveryone(11),
  date(100);

  const CustomMessageType(this.value);

  factory CustomMessageType.fromValue(int val) {
    switch (val) {
      case 1:
        return CustomMessageType.text;
      case 2:
        return CustomMessageType.reply;
      case 3:
        return CustomMessageType.image;
      case 4:
        return CustomMessageType.video;
      case 5:
        return CustomMessageType.audio;
      case 6:
        return CustomMessageType.file;
      case 7:
        return CustomMessageType.location;
      case 8:
        return CustomMessageType.block;
      case 9:
        return CustomMessageType.unblock;
      case 10:
        return CustomMessageType.deletedForMe;
      case 11:
        return CustomMessageType.deletedForEveryone;
      case 100:
        return CustomMessageType.date;
      default:
        return CustomMessageType.text;
    }
  }

  // factory CustomMessageType.fromString(String value) {
  //   const map = <String, CustomMessageType>{
  //     'text': CustomMessageType.text,
  //   };
  // }

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
