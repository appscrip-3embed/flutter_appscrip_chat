import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:objectbox/objectbox.dart';

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
  });
  int id;
  int? unreadMessagesCount;
  final opponentDetails = ToOne<UserDetails>();
  bool? messagingDisabled;
  int? membersCount;
  int? lastMessageSentAt;
  final lastMessageDetails = ToOne<LastMessageDetails>();
  bool? isGroup;

  String? conversationTitle;
  String? conversationImageUrl;
  String? conversationId;
  final config = ToOne<ConversationConfigModel>();
}
