import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class DBConversationModel {
  // factory DBConversationModel.fromMap(Map<String, dynamic> map) =>
  //     DBConversationModel(
  //       unreadMessagesCount: map['unreadMessagesCount'] as int? ?? 0,
  //       messagingDisabled: map['messagingDisabled'] as bool? ?? false,
  //       membersCount: map['membersCount'] as int? ?? 0,
  //       lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
  //       isGroup: map['isGroup'] as bool? ?? false,
  //       conversationTitle: map['conversationTitle'] as String?,
  //       conversationImageUrl: map['conversationImageUrl'] as String?,
  //       conversationId: map['conversationId'] as String? ?? '',
  //     );
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
  // @Backlink('conversation')
  // final messages = ToMany<DBMessageModel>();
}
