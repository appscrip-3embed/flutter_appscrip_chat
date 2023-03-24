import 'package:objectbox/objectbox.dart';

@Entity()
class ForwardMessageModel {
  ForwardMessageModel({
    this.id = 0,
    required this.conversationId,
    required this.messages,
  });
  int id;
  String conversationId;
  List<String> messages;
  // final messages = ToMany<DBMessageModel>();
}
