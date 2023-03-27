import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class MqttActionModel {
  factory MqttActionModel.fromJson(String source) =>
      MqttActionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MqttActionModel.fromMap(Map<String, dynamic> map) => MqttActionModel(
        conversationId: map['conversationId'] != null
            ? map['conversationId'] as String
            : null,
        messageId: map['messageId'] as String?,
        userDetails: map['userId'] != null
            ? MqttUserModel(
                userId: map['userId'] as String,
                userName: map['userName'] as String,
                userIdentifier: map['userIdentifier'] as String?,
                profileImageUrl: map['userProfileImageUrl'] as String?,
              )
            : null,
        opponentDetails: map['opponentId'] != null
            ? MqttUserModel(
                userId: map['opponentId'] as String,
                userName: map['opponentName'] as String,
                userIdentifier: map['opponentIdentifier'] as String?,
                profileImageUrl: map['opponentProfileImageUrl'] as String?,
              )
            : null,
        initiatorDetails: map['initiatorId'] != null
            ? MqttUserModel(
                userId: map['initiatorId'] as String,
                userName: map['initiatorName'] as String,
                userIdentifier: map['initiatorIdentifier'] as String?,
                profileImageUrl: map['initiatorProfileImageUrl'] as String?,
              )
            : null,
        sentAt: map['sentAt'] as int,
        action: ActionEvents.fromName(map['action'] as String),
      );

  const MqttActionModel({
    this.conversationId,
    this.userDetails,
    this.opponentDetails,
    this.initiatorDetails,
    this.messageId,
    required this.sentAt,
    required this.action,
  });
  final String? conversationId;
  final MqttUserModel? userDetails;
  final MqttUserModel? opponentDetails;
  final MqttUserModel? initiatorDetails;
  final int sentAt;
  final String? messageId;
  final ActionEvents action;

  MqttActionModel copyWith({
    String? conversationId,
    MqttUserModel? userDetails,
    MqttUserModel? opponentDetails,
    MqttUserModel? initiatorDetails,
    int? sentAt,
    ActionEvents? action,
  }) =>
      MqttActionModel(
        conversationId: conversationId ?? this.conversationId,
        userDetails: userDetails ?? this.userDetails,
        opponentDetails: opponentDetails ?? this.opponentDetails,
        initiatorDetails: initiatorDetails ?? this.initiatorDetails,
        sentAt: sentAt ?? this.sentAt,
        action: action ?? this.action,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'conversationId': conversationId,
        'userDetails': userDetails?.toMap(),
        'opponentDetails': opponentDetails?.toMap(),
        'initiatorDetails': initiatorDetails?.toMap(),
        'sentAt': sentAt,
        'action': action.name,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'MqttActionModel(conversationId: $conversationId, userDetails: $userDetails, opponentDetails: $opponentDetails, initiatorDetails: $initiatorDetails, sentAt: $sentAt, action: $action)';

  @override
  bool operator ==(covariant MqttActionModel other) {
    if (identical(this, other)) return true;

    return other.conversationId == conversationId &&
        other.userDetails == userDetails &&
        other.opponentDetails == opponentDetails &&
        other.initiatorDetails == initiatorDetails &&
        other.sentAt == sentAt &&
        other.action == action;
  }

  @override
  int get hashCode =>
      conversationId.hashCode ^
      userDetails.hashCode ^
      opponentDetails.hashCode ^
      initiatorDetails.hashCode ^
      sentAt.hashCode ^
      action.hashCode;
}
