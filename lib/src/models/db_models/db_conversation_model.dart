import 'package:appscrip_chat_component/appscrip_chat_component.dart';

@Entity()
class DBConversationModel {
  DBConversationModel({
    this.id = 0,
    this.unreadMessagesCount,
    this.messagingDisabled,
    this.lastMessageSentAt,
    this.membersCount,
    this.isGroup,
    this.conversationTitle,
    this.conversationImageUrl,
    this.conversationId,
    this.metaData,
    required this.messages,
  });
  int id;
  int? unreadMessagesCount;
  final opponentDetails = ToOne<UserDetails>();
  bool? messagingDisabled;
  int? membersCount;
  int? lastMessageSentAt;
  final lastMessageDetails = ToOne<LastMessageDetails>();
  bool? isGroup;
  List<String> messages;
  String? conversationTitle;
  String? conversationImageUrl;
  String? conversationId;

  final config = ToOne<ConversationConfigModel>();
  @Transient()
  IsmChatMetaData? metaData;

  // @Backlink('conversation')
  // final messages = ToMany<DBMessageModel>();

  String get dbMetadata => metaData?.toJson() ?? '';

  set dbMetadata(String value) => metaData = IsmChatMetaData.fromJson(value);
}
