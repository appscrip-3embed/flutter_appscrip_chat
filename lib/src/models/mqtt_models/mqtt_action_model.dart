import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttActionModel {
  factory IsmChatMqttActionModel.fromJson(String source) =>
      IsmChatMqttActionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  factory IsmChatMqttActionModel.fromMap(Map<String, dynamic> map) =>
      IsmChatMqttActionModel(
        conversationId: map['conversationId'] != null
            ? map['conversationId'] as String
            : null,
        messageId: map['messageId'] as String?,
        messageIds: map['messageIds'] != null
            ? List<String>.from((map['messageIds'] as List<dynamic>)
                .map<dynamic>((dynamic x) => x))
            : [],
        userDetails: map['userId'] != null
            ? IsmChatMqttUserModel(
                userId: map['userId'] as String,
                userName:
                    map['userName'] != null ? map['userName'] as String : '',
                userIdentifier: map['userIdentifier'] as String?,
                profileImageUrl: map['userProfileImageUrl'] as String?,
              )
            : null,
        opponentDetails: map['opponentId'] != null
            ? IsmChatMqttUserModel(
                userId: map['opponentId'] as String,
                userName: map['opponentName'] as String,
                userIdentifier: map['opponentIdentifier'] as String?,
                profileImageUrl: map['opponentProfileImageUrl'] as String?,
              )
            : null,
        initiatorDetails: map['initiatorId'] != null
            ? IsmChatMqttUserModel(
                userId: map['initiatorId'] as String,
                userName: map['initiatorName'] as String,
                userIdentifier: map['initiatorIdentifier'] as String?,
                profileImageUrl: map['initiatorProfileImageUrl'] as String?,
              )
            : null,
        conversationDetails: map['conversationDetails'] != null
            ? IsmChatConversationModel.fromMap(
                map['conversationDetails'] as Map<String, dynamic>)
            : null,
        sentAt: map['sentAt'] as int,
        lastMessageSentAt: map['lastMessageSentAt'] as int?,
        initiatorId: map['initiatorId'] as String? ?? '',
        initiatorName: map['initiatorName'] as String? ?? '',
        memberId: map['memberId'] as String? ?? '',
        memberName: map['memberName'] as String? ?? '',
        action: IsmChatActionEvents.fromName(map['action'] as String),
      );

  const IsmChatMqttActionModel(
      {this.conversationId,
      this.userDetails,
      this.opponentDetails,
      this.initiatorDetails,
      this.conversationDetails,
      this.messageId,
      this.messageIds,
      this.lastMessageSentAt,
      required this.sentAt,
      required this.action,
      this.initiatorId,
      this.initiatorName,
      this.memberId,
      this.memberName});
  final String? conversationId;
  final IsmChatMqttUserModel? userDetails;
  final IsmChatMqttUserModel? opponentDetails;
  final IsmChatMqttUserModel? initiatorDetails;
  final IsmChatConversationModel? conversationDetails;
  final int sentAt;
  final int? lastMessageSentAt;
  final String? messageId;
  final List<String>? messageIds;
  final IsmChatActionEvents action;
  final String? memberId;
  final String? memberName;
  final String? initiatorName;
  final String? initiatorId;

  IsmChatMqttActionModel copyWith(
          {String? conversationId,
          IsmChatMqttUserModel? userDetails,
          IsmChatMqttUserModel? opponentDetails,
          IsmChatMqttUserModel? initiatorDetails,
          int? sentAt,
          IsmChatActionEvents? action,
          String? memberId,
          String? memberName,
          String? initiatorName,
          String? initiatorId}) =>
      IsmChatMqttActionModel(
          conversationId: conversationId ?? this.conversationId,
          userDetails: userDetails ?? this.userDetails,
          opponentDetails: opponentDetails ?? this.opponentDetails,
          initiatorDetails: initiatorDetails ?? this.initiatorDetails,
          sentAt: sentAt ?? this.sentAt,
          action: action ?? this.action,
          memberId: memberId ?? this.memberId,
          memberName: memberName ?? this.memberName,
          initiatorName: initiatorName ?? this.initiatorName,
          initiatorId: initiatorId ?? this.initiatorId);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'conversationId': conversationId,
        'userDetails': userDetails?.toMap(),
        'opponentDetails': opponentDetails?.toMap(),
        'initiatorDetails': initiatorDetails?.toMap(),
        'sentAt': sentAt,
        'action': action.name,
        'memberId': memberId,
        'memberName': memberName,
        'initiatorName': initiatorName,
        'initiatorId': initiatorId
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'MqttActionModel(conversationId: $conversationId, messageId: $messageId, messageIds: $messageIds, userDetails: $userDetails, opponentDetails: $opponentDetails, initiatorDetails: $initiatorDetails, sentAt: $sentAt, action: $action, memberId : $memberId, memberName : $memberName, initiatorName : $initiatorName , initiatorId : $initiatorId)';

  @override
  bool operator ==(covariant IsmChatMqttActionModel other) {
    if (identical(this, other)) return true;

    return other.conversationId == conversationId &&
        other.userDetails == userDetails &&
        other.opponentDetails == opponentDetails &&
        other.initiatorDetails == initiatorDetails &&
        other.sentAt == sentAt &&
        other.memberId == memberId &&
        other.memberName == memberName &&
        other.initiatorId == initiatorId &&
        other.initiatorName == initiatorName &&
        other.action == action;
  }

  @override
  int get hashCode =>
      conversationId.hashCode ^
      userDetails.hashCode ^
      opponentDetails.hashCode ^
      initiatorDetails.hashCode ^
      sentAt.hashCode ^
      memberId.hashCode ^
      memberName.hashCode ^
      initiatorId.hashCode ^
      initiatorName.hashCode ^
      action.hashCode;
}
