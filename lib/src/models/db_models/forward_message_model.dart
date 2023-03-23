
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/models/chat_message_model.dart';
import 'package:objectbox/objectbox.dart';
@Entity()
class ForwardMessageModel {
  ForwardMessageModel({
    this.id = 0,
    required this.conversationId,
  });
  int id;
  String conversationId;
  final messages = ToMany<DBMessageModel>();
}
