import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBMessageModel {
  DBMessageModel({
    this.id = 0,
    this.body,
    this.action,
    this.sentAt,
    this.readByAll,
    this.messagingDisabled,
    this.deliveredToAll,
    this.customType,
    this.conversationId,
    this.parentMessageId,
    this.messageId,
    this.messageType,
    this.sentByMe,
  });
  int id;
  String? body;
  String? action;
  int? sentAt;
  String? receiverId;
  bool? readByAll;
  final senderInfo = ToOne<UserDetails>();
  bool? messagingDisabled;
  final attachments = ToMany<AttachmentModel>();
  final conversation = ToOne<DBConversationModel>();
  bool? deliveredToAll;
  String? conversationId;
  String? parentMessageId;
  String? messageId;
  @Transient()
  MessageType? messageType;
  @Transient()
  CustomMessageType? customType;
  bool? sentByMe;
  int? get messageIndex => messageType?.index;

  set messageIndex(int? value) {
    if (value == null) {
      messageType = null;
    }
    if (value! < 0 || value >= MessageType.values.length) {
      messageType = MessageType.normal;
    }
    messageType = MessageType.values[value];
  }

  int? get customMessageIndex => customType?.index;

  set customMessageIndex(int? value) {
    if (value == null) {
      customType = null;
    }
    if (value! < 0 || value >= CustomMessageType.values.length) {
      customType = CustomMessageType.text;
    }
    customType = CustomMessageType.values[value];
  }
}
