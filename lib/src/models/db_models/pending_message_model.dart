
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:objectbox/objectbox.dart';
@Entity()
class PendingMessageModel {
  PendingMessageModel({
    this.id = 0,
    required this.conversationId,
  });
  int id;
  String conversationId;
  final messages = ToMany<DBMessageModel>();
}
