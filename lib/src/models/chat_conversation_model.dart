// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';

class IsmChatConversationModel {
  factory IsmChatConversationModel.fromJson(String source) =>
      IsmChatConversationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  factory IsmChatConversationModel.fromMap(Map<String, dynamic> map) =>
      IsmChatConversationModel(
        updatedAt: map['updatedAt'] as int? ?? 0,
        unreadMessagesCount: map['unreadMessagesCount'] as int? ?? 0,
        userIds: map['userIds'] == null
            ? []
            : List<String>.from(map['userIds'] as List<dynamic>),
        privateOneToOne: map['privateOneToOne'] as bool? ?? false,
        opponentDetails:
            UserDetails.fromMap(map['opponentDetails'] as Map<String, dynamic>),
        metaData: map['metaData'] == null
            ? IsmChatMetaData()
            : IsmChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        messagingDisabled: map['messagingDisabled'] as bool? ?? false,
        membersCount: map['membersCount'] as int? ?? 0,
        lastReadAt: map['lastReadAt'].runtimeType == List
            ? (map['lastReadAt'] as List)
                .map(
                    (e) => IsmChatLastReadAt.fromMap(e as Map<String, dynamic>))
                .toList()
            : IsmChatLastReadAt.fromNetworkMap(
                map['lastReadAt'] as Map<String, dynamic>? ?? {}),
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        lastMessageDetails: map['lastMessageDetails'] != null
            ? LastMessageDetails.fromMap(
                map['lastMessageDetails'] as Map<String, dynamic>)
            : null,
        isGroup: map['isGroup'] as bool? ?? false,
        createdAt: map['createdAt'] as int? ?? 0,
        createdBy: map['createdBy'] as String?,
        createdByUserName: map['createdByUserName'] as String? ?? '',
        conversationType: IsmChatConversationType.fromValue(
            map['conversationType'] as int? ?? 1),
        conversationTitle: map['conversationTitle'] as String?,
        conversationImageUrl: map['conversationImageUrl'] as String?,
        conversationId: map['conversationId'] as String? ?? '',
        config: ConversationConfigModel.fromMap(
            map['config'] as Map<String, dynamic>),
        members: map['members'] == null
            ? []
            : List<UserDetails>.from(
                (map['members'] as List).map(
                  (e) => UserDetails.fromMap(e as Map<String, dynamic>),
                ),
              ),
        usersOwnDetails: map['usersOwnDetails'] != null
            ? IsmChatUserOwnDetails.fromMap(
                map['usersOwnDetails'] as Map<String, dynamic>)
            : null,
        messages: map['messages'] != null
            ? (map['messages'] as List)
                .map(
                  (e) => IsmChatMessageModel.fromMap(e as Map<String, dynamic>),
                )
                .toList()
            : [],
      );

  IsmChatConversationModel({
    this.updatedAt,
    this.unreadMessagesCount,
    this.privateOneToOne,
    this.opponentDetails,
    this.metaData,
    this.messagingDisabled,
    this.membersCount,
    this.lastReadAt,
    this.lastMessageSentAt,
    this.lastMessageDetails,
    this.isGroup,
    this.createdAt,
    this.conversationType,
    this.conversationTitle,
    this.conversationImageUrl,
    this.conversationId,
    this.config,
    this.userIds,
    this.members,
    this.usersOwnDetails,
    this.createdBy,
    this.createdByUserName,
    this.messages,
  });

  final int? updatedAt;
  final int? unreadMessagesCount;
  final List<String>? userIds;
  final bool? privateOneToOne;
  final UserDetails? opponentDetails;
  final IsmChatMetaData? metaData;
  final bool? messagingDisabled;
  final int? membersCount;
  final List<IsmChatLastReadAt>? lastReadAt;
  final int? lastMessageSentAt;
  final LastMessageDetails? lastMessageDetails;
  final bool? isGroup;
  final IsmChatConversationType? conversationType;
  final int? createdAt;
  final String? conversationTitle;
  final String? conversationImageUrl;
  final String? conversationId;
  final ConversationConfigModel? config;
  final List<UserDetails>? members;
  final IsmChatUserOwnDetails? usersOwnDetails;
  final String? createdBy;
  final String? createdByUserName;
  final List<IsmChatMessageModel>? messages;

  String get replyName =>
      IsmChatConfig.communicationConfig.userConfig.userName.isNotEmpty
          ? IsmChatConfig.communicationConfig.userConfig.userName
          : opponentDetails?.userName ?? '';

  String get chatName => conversationTitle ?? opponentDetails?.userName ?? '';

  String get profileUrl =>
      conversationImageUrl ?? opponentDetails?.profileUrl ?? '';

  IsmChatConversationModel copyWith({
    int? updatedAt,
    int? unreadMessagesCount,
    List<String>? searchableTags,
    bool? privateOneToOne,
    UserDetails? opponentDetails,
    IsmChatMetaData? metaData,
    bool? messagingDisabled,
    int? membersCount,
    List<IsmChatLastReadAt>? lastReadAt,
    LastMessageDetails? lastMessageDetails,
    int? lastMessageSentAt,
    bool? isGroup,
    dynamic customType,
    String? createdByUserName,
    String? createdByUserImageUrl,
    String? createdBy,
    int? createdAt,
    IsmChatConversationType? conversationType,
    String? conversationTitle,
    String? conversationImageUrl,
    String? conversationId,
    ConversationConfigModel? config,
    int? adminCount,
    List<UserDetails>? members,
    IsmChatUserOwnDetails? usersOwnDetails,
    List<IsmChatMessageModel>? messages,
  }) =>
      IsmChatConversationModel(
        updatedAt: updatedAt ?? this.updatedAt,
        unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
        privateOneToOne: privateOneToOne ?? this.privateOneToOne,
        opponentDetails: opponentDetails ?? this.opponentDetails,
        metaData: metaData ?? this.metaData,
        messagingDisabled: messagingDisabled ?? this.messagingDisabled,
        membersCount: membersCount ?? this.membersCount,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
        lastMessageDetails: lastMessageDetails ?? this.lastMessageDetails,
        isGroup: isGroup ?? this.isGroup,
        conversationType: conversationType ?? this.conversationType,
        conversationTitle: conversationTitle ?? this.conversationTitle,
        conversationImageUrl: conversationImageUrl ?? this.conversationImageUrl,
        conversationId: conversationId ?? this.conversationId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        createdByUserName: createdByUserName ?? this.createdByUserName,
        config: config ?? this.config,
        members: members ?? this.members,
        usersOwnDetails: usersOwnDetails ?? this.usersOwnDetails,
        messages: messages ?? this.messages,
      );

  Map<String, dynamic> toMap() => {
        'isGroup': isGroup,
        'createdBy': createdBy,
        'createdByUserName': createdByUserName,
        'conversationType': conversationType?.value,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl,
        'conversationId': conversationId,
        'config': config?.toMap(),
        'createdAt': createdAt,
        'members': members?.map((e) => e.toMap()).toList(),
        'usersOwnDetails': usersOwnDetails?.toMap(),
        'messages': messages?.map((e) => e.toMap()).toList(),
        'updatedAt': updatedAt,
        'unreadMessagesCount': unreadMessagesCount,
        'userIds': userIds,
        'privateOneToOne': privateOneToOne,
        'opponentDetails': opponentDetails?.toMap(),
        'metaData': metaData?.toMap(),
        'messagingDisabled': messagingDisabled,
        'membersCount': membersCount,
        'lastReadAt': lastReadAt?.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
        'lastMessageDetails': lastMessageDetails?.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmChatConversationModel(updatedAt: $updatedAt, unreadMessagesCount: $unreadMessagesCount, userIds: $userIds, privateOneToOne: $privateOneToOne, opponentDetails: $opponentDetails, metaData: $metaData, messagingDisabled: $messagingDisabled, membersCount: $membersCount, lastReadAt: $lastReadAt, lastMessageSentAt: $lastMessageSentAt, lastMessageDetails: $lastMessageDetails, isGroup: $isGroup, conversationType: $conversationType, createdAt: $createdAt, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, config: $config, members: $members, usersOwnDetails: $usersOwnDetails, createdBy: $createdBy, createdByUserName: $createdByUserName, messages: $messages)';

  @override
  bool operator ==(covariant IsmChatConversationModel other) {
    if (identical(this, other)) return true;

    return other.updatedAt == updatedAt &&
        other.unreadMessagesCount == unreadMessagesCount &&
        listEquals(other.userIds, userIds) &&
        other.privateOneToOne == privateOneToOne &&
        other.opponentDetails == opponentDetails &&
        other.metaData == metaData &&
        other.messagingDisabled == messagingDisabled &&
        other.membersCount == membersCount &&
        listEquals(other.lastReadAt, lastReadAt) &&
        other.lastMessageSentAt == lastMessageSentAt &&
        other.lastMessageDetails == lastMessageDetails &&
        other.isGroup == isGroup &&
        other.conversationType == conversationType &&
        other.createdAt == createdAt &&
        other.conversationTitle == conversationTitle &&
        other.conversationImageUrl == conversationImageUrl &&
        other.conversationId == conversationId &&
        other.config == config &&
        listEquals(other.members, members) &&
        other.usersOwnDetails == usersOwnDetails &&
        other.createdBy == createdBy &&
        other.createdByUserName == createdByUserName &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode =>
      updatedAt.hashCode ^
      unreadMessagesCount.hashCode ^
      userIds.hashCode ^
      privateOneToOne.hashCode ^
      opponentDetails.hashCode ^
      metaData.hashCode ^
      messagingDisabled.hashCode ^
      membersCount.hashCode ^
      lastReadAt.hashCode ^
      lastMessageSentAt.hashCode ^
      lastMessageDetails.hashCode ^
      isGroup.hashCode ^
      conversationType.hashCode ^
      createdAt.hashCode ^
      conversationTitle.hashCode ^
      conversationImageUrl.hashCode ^
      conversationId.hashCode ^
      config.hashCode ^
      members.hashCode ^
      usersOwnDetails.hashCode ^
      createdBy.hashCode ^
      createdByUserName.hashCode ^
      messages.hashCode;
}
