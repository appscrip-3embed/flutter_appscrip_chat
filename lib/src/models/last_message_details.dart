import 'dart:convert';

import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:objectbox/objectbox.dart';
@Entity()
class LastMessageDetails {
  factory LastMessageDetails.fromJson(String source) =>
      LastMessageDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory LastMessageDetails.fromMap(Map<String, dynamic> map) =>
      LastMessageDetails(
        showInConversation: map['showInConversation'] as bool? ?? false,
        sentAt: map['sentAt'] as int,
        senderName: map['senderName'] as String? ?? '',
        messageType: map['messageType'] as int? ?? 0,
        messageId: map['messageId'] as String? ?? '',
        conversationId: map['conversationId'] as String? ?? '',
        body: ChatUtility.decodePayload(map['body'] as String? ?? ''),
      );

   LastMessageDetails({
    this.id = 0,
    required this.showInConversation,
    required this.sentAt,
    required this.senderName,
    required this.messageType,
    required this.messageId,
    required this.conversationId,
    required this.body,
  });
  int id;
  final bool showInConversation;
  final int sentAt;
  final String senderName;
  final int messageType;
  final String messageId;
  final String conversationId;
  final String body;

  LastMessageDetails copyWith({
    bool? showInConversation,
    int? sentAt,
    String? senderName,
    int? messageType,
    String? messageId,
    String? conversationId,
    String? body,
  }) =>
      LastMessageDetails(
        showInConversation: showInConversation ?? this.showInConversation,
        sentAt: sentAt ?? this.sentAt,
        senderName: senderName ?? this.senderName,
        messageType: messageType ?? this.messageType,
        messageId: messageId ?? this.messageId,
        conversationId: conversationId ?? this.conversationId,
        body: body ?? this.body,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'showInConversation': showInConversation,
        'sentAt': sentAt,
        'senderName': senderName,
        'messageType': messageType,
        'messageId': messageId,
        'conversationId': conversationId,
        'body': body,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'LastMessageDetails(showInConversation: $showInConversation, sentAt: $sentAt, senderName: $senderName, messageType: $messageType, messageId: $messageId, conversationId: $conversationId, body: $body)';

  @override
  bool operator ==(covariant LastMessageDetails other) {
    if (identical(this, other)) return true;

    return other.showInConversation == showInConversation &&
        other.sentAt == sentAt &&
        other.senderName == senderName &&
        other.messageType == messageType &&
        other.messageId == messageId &&
        other.conversationId == conversationId &&
        other.body == body;
  }

  @override
  int get hashCode =>
      showInConversation.hashCode ^
      sentAt.hashCode ^
      senderName.hashCode ^
      messageType.hashCode ^
      messageId.hashCode ^
      conversationId.hashCode ^
      body.hashCode;
}
