import 'dart:convert';

import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LastMessageDetails {
  factory LastMessageDetails.fromJson(String source) =>
      LastMessageDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory LastMessageDetails.fromMap(Map<String, dynamic> map) {
    var details = LastMessageDetails(
        showInConversation: map['showInConversation'] as bool? ?? false,
        sentAt: map['sentAt'] as int,
        senderName: map['senderName'] as String? ??
            map['userName'] as String? ??
            map['initiatorName'] as String? ??
            '',
        senderId: map['senderId'] as String? ??
            map['userId'] as String? ??
            map['initiatorId'] as String? ??
            '',
        messageType: map['messageType'] as int? ?? 0,
        messageId:
            map['messageId'] as String? ?? map['userId'] as String? ?? '',
        conversationId: map['conversationId'] as String? ?? '',
        body: IsmChatUtility.decodePayload(map['body'] as String? ?? ''),
        deliverCount: map['deliveredTo'] != null
            ? (map['deliveredTo'] as List).length
            : 0,
        readCount: map['readBy'] != null ? (map['readBy'] as List).length : 0,
        customType: map['customType'] != null
            ? IsmChatCustomMessageType.fromString(map['customType'] as String)
            : map['action'] != null
                ? IsmChatCustomMessageType.fromAction(map['action'] as String)
                : null,
        sentByMe: true,
        members: map['members'] != null
            ? (map['members'] as List)
                .map((e) => e['memberName'] as String)
                .toList()
            : <String>[],
        reactionType: map['reactionType'] as String);
    return details.copyWith(
      sentByMe: details.senderId.isNotEmpty
          ? details.senderId ==
              IsmChatConfig.communicationConfig.userConfig.userId
          : true,
    );
  }

  LastMessageDetails(
      {this.id = 0,
      required this.showInConversation,
      required this.sentAt,
      required this.senderName,
      this.senderId = '',
      required this.messageType,
      required this.messageId,
      required this.conversationId,
      required this.body,
      this.deliverCount = 0,
      this.readCount = 0,
      required this.sentByMe,
      this.customType,
      this.members,
      this.reactionType});
  int id;
  final bool showInConversation;
  final int sentAt;
  final String senderName;
  final String senderId;
  final int messageType;
  final String messageId;
  final String conversationId;
  final String body;
  final int deliverCount;
  final int readCount;
  final bool sentByMe;
  final List<String>? members;
  final String? reactionType;
  @Transient()
  IsmChatCustomMessageType? customType;

  int? get dbCustomType => customType?.value;
  set dbCustomType(int? type) {
    customType = IsmChatCustomMessageType.fromValue(type ?? 1);
  }

  LastMessageDetails copyWith({
    bool? showInConversation,
    int? sentAt,
    String? senderName,
    String? senderId,
    int? messageType,
    String? messageId,
    String? conversationId,
    String? body,
    int? deliverCount,
    int? readCount,
    bool? sentByMe,
    IsmChatCustomMessageType? customType,
    List<String>? members,
    String? reactionType,
  }) =>
      LastMessageDetails(
        showInConversation: showInConversation ?? this.showInConversation,
        sentAt: sentAt ?? this.sentAt,
        senderName: senderName ?? this.senderName,
        senderId: senderId ?? this.senderId,
        messageType: messageType ?? this.messageType,
        messageId: messageId ?? this.messageId,
        conversationId: conversationId ?? this.conversationId,
        body: body ?? this.body,
        customType: customType ?? this.customType,
        deliverCount: deliverCount ?? this.deliverCount,
        readCount: readCount ?? this.readCount,
        sentByMe: sentByMe ?? this.sentByMe,
        members: members ?? this.members,
        reactionType: reactionType ?? this.reactionType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'showInConversation': showInConversation,
        'sentAt': sentAt,
        'senderName': senderName,
        'senderId': senderId,
        'messageType': messageType,
        'messageId': messageId,
        'conversationId': conversationId,
        'body': body,
        'customType': customType?.value,
        'deliverCount': deliverCount,
        'readCount': readCount,
        'sentByMe': sentByMe,
        'members': members,
        'reactionType': reactionType,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'LastMessageDetails(showInConversation: $showInConversation, sentAt: $sentAt, senderName: $senderName, senderId: $senderId, messageType: $messageType, messageId: $messageId, conversationId: $conversationId, body: $body, customType: $customType, deliverCount: $deliverCount, readCount: $readCount, sentByMe: $sentByMe, members: $members,  reactionType : $reactionType,)';

  @override
  bool operator ==(covariant LastMessageDetails other) {
    if (identical(this, other)) return true;

    return other.showInConversation == showInConversation &&
        other.sentAt == sentAt &&
        other.senderName == senderName &&
        other.senderId == senderId &&
        other.messageType == messageType &&
        other.messageId == messageId &&
        other.conversationId == conversationId &&
        other.body == body &&
        other.readCount == readCount &&
        other.deliverCount == deliverCount &&
        other.sentByMe == sentByMe &&
        other.members == members &&
        other.customType == customType &&
        other.reactionType == reactionType;
  }

  @override
  int get hashCode =>
      showInConversation.hashCode ^
      sentAt.hashCode ^
      senderName.hashCode ^
      senderId.hashCode ^
      messageType.hashCode ^
      messageId.hashCode ^
      conversationId.hashCode ^
      body.hashCode ^
      deliverCount.hashCode ^
      readCount.hashCode ^
      sentByMe.hashCode ^
      members.hashCode ^
      customType.hashCode ^
      reactionType.hashCode;
}
