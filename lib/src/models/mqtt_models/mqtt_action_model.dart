// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatMqttActionModel {
  factory IsmChatMqttActionModel.fromJson(String source) =>
      IsmChatMqttActionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  factory IsmChatMqttActionModel.fromMap(Map<String, dynamic> map) =>
      IsmChatMqttActionModel(
        conversationId: map['conversationId'] as String? ?? '',
        messageId: map['messageId'] as String? ?? '',
        messageIds: map['messageIds'] != null
            ? List<String>.from((map['messageIds'] as List<dynamic>)
                .map<dynamic>((dynamic x) => x))
            : [],
        userDetails: map['userId'] != null
            ? IsmChatMqttUserModel(
                userId: map['userId'] as String? ?? '',
                userName: map['userName'] as String? ?? '',
                userIdentifier: map['userIdentifier'] as String? ?? '',
                profileImageUrl: map['userProfileImageUrl'] as String? ?? '',
              )
            : null,
        opponentDetails: map['opponentId'] != null
            ? IsmChatMqttUserModel(
                userId: map['opponentId'] as String? ?? '',
                userName: map['opponentName'] as String? ?? '',
                userIdentifier: map['opponentIdentifier'] as String? ?? '',
                profileImageUrl:
                    map['opponentProfileImageUrl'] as String? ?? '',
              )
            : null,
        initiatorDetails: map['initiatorId'] != null
            ? IsmChatMqttUserModel(
                userId: map['initiatorId'] as String? ?? '',
                userName: map['initiatorName'] as String? ?? '',
                userIdentifier: map['initiatorIdentifier'] as String? ?? '',
                profileImageUrl:
                    map['initiatorProfileImageUrl'] as String? ?? '',
              )
            : null,
        conversationDetails: map['conversationDetails'] != null
            ? IsmChatConversationModel.fromMap(
                map['conversationDetails'] as Map<String, dynamic>)
            : null,
        sentAt: map['sentAt'] as int? ?? 0,
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        initiatorId: map['initiatorId'] as String? ?? '',
        initiatorName: map['initiatorName'] as String? ?? '',
        memberId: map['memberId'] as String? ?? '',
        memberName: map['memberName'] as String? ?? '',
        action: IsmChatActionEvents.fromName(map['action'] as String? ?? ''),
        reactionType: map['reactionType'] as String? ?? '',
        reactionsCount: map['reactionsCount'] as int? ?? 0,
        members: map['members'] != null
            ? List<UserDetails>.from(
                (map['members'] as List).map(
                  (dynamic x) => UserDetails.fromMap(x as Map<String, dynamic>),
                ),
              )
            : [],
      );

  const IsmChatMqttActionModel({
    this.conversationId,
    this.userDetails,
    this.opponentDetails,
    this.initiatorDetails,
    this.conversationDetails,
    this.messageId,
    this.messageIds,
    this.lastMessageSentAt,
    required this.sentAt,
    required this.action,
    this.reactionType,
    this.reactionsCount,
    this.initiatorId,
    this.initiatorName,
    this.memberId,
    this.memberName,
    this.members,
  });
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
  final String? reactionType;
  final int? reactionsCount;
  final List<UserDetails>? members;

  IsmChatMqttActionModel copyWith({
    String? conversationId,
    IsmChatMqttUserModel? userDetails,
    IsmChatMqttUserModel? opponentDetails,
    IsmChatMqttUserModel? initiatorDetails,
    int? sentAt,
    IsmChatActionEvents? action,
    String? memberId,
    String? memberName,
    String? initiatorName,
    String? initiatorId,
    List<UserDetails>? members,
  }) =>
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
          initiatorId: initiatorId ?? this.initiatorId,
          members: members ?? this.members);

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
        'initiatorId': initiatorId,
        'members': members
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

class Members {
  final String? memberProfileImageUrl;
  final String? memberName;
  final String? memberIdentifier;
  final String? memberId;
  Members({
    this.memberProfileImageUrl,
    this.memberName,
    this.memberIdentifier,
    this.memberId,
  });

  Members copyWith({
    String? memberProfileImageUrl,
    String? memberName,
    String? memberIdentifier,
    String? memberId,
  }) =>
      Members(
        memberProfileImageUrl:
            memberProfileImageUrl ?? this.memberProfileImageUrl,
        memberName: memberName ?? this.memberName,
        memberIdentifier: memberIdentifier ?? this.memberIdentifier,
        memberId: memberId ?? this.memberId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'memberProfileImageUrl': memberProfileImageUrl,
        'memberName': memberName,
        'memberIdentifier': memberIdentifier,
        'memberId': memberId,
      };

  factory Members.fromMap(Map<String, dynamic> map) => Members(
        memberProfileImageUrl: map['memberProfileImageUrl'] != null
            ? map['memberProfileImageUrl'] as String
            : null,
        memberName:
            map['memberName'] != null ? map['memberName'] as String : null,
        memberIdentifier: map['memberIdentifier'] != null
            ? map['memberIdentifier'] as String
            : null,
        memberId: map['memberId'] != null ? map['memberId'] as String : null,
      );

  String toJson() => json.encode(toMap());

  factory Members.fromJson(String source) =>
      Members.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Members(memberProfileImageUrl: $memberProfileImageUrl, memberName: $memberName, memberIdentifier: $memberIdentifier, memberId: $memberId)';

  @override
  bool operator ==(covariant Members other) {
    if (identical(this, other)) return true;

    return other.memberProfileImageUrl == memberProfileImageUrl &&
        other.memberName == memberName &&
        other.memberIdentifier == memberIdentifier &&
        other.memberId == memberId;
  }

  @override
  int get hashCode =>
      memberProfileImageUrl.hashCode ^
      memberName.hashCode ^
      memberIdentifier.hashCode ^
      memberId.hashCode;
}
