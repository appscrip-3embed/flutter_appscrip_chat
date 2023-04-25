import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
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
        lastReadAt: IsmChatLastReadAt.fromNetworkMap(
            map['lastReadAt'] as Map<String, dynamic>? ?? {}),
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        lastMessageDetails: map['lastMessageDetails'] != null
            ? LastMessageDetails.fromMap(
                map['lastMessageDetails'] as Map<String, dynamic>)
            : null,
        isGroup: map['isGroup'] as bool? ?? false,
        conversationType: IsmChatConversationType.fromValue(
            map['conversationType'] as int? ?? 1),
        conversationTitle: map['conversationTitle'] as String?,
        conversationImageUrl: map['conversationImageUrl'] as String?,
        conversationId: map['conversationId'] as String? ?? '',
        config: ConversationConfigModel.fromMap(
            map['config'] as Map<String, dynamic>),
      );

  factory IsmChatConversationModel.fromDB(DBConversationModel dbConversation) =>
      IsmChatConversationModel(
        updatedAt: 0,
        unreadMessagesCount: dbConversation.unreadMessagesCount,
        privateOneToOne: false,
        opponentDetails: dbConversation.opponentDetails.target,
        messagingDisabled: dbConversation.messagingDisabled,
        membersCount: dbConversation.membersCount,
        lastMessageSentAt: dbConversation.lastMessageSentAt,
        lastMessageDetails: dbConversation.lastMessageDetails.target,
        isGroup: dbConversation.isGroup,
        conversationType: IsmChatConversationType.public,
        conversationTitle: dbConversation.conversationTitle,
        conversationImageUrl: dbConversation.conversationImageUrl,
        conversationId: dbConversation.conversationId,
        config: dbConversation.config.target,
      );

  IsmChatConversationModel({
    this.updatedAt,
    this.unreadMessagesCount,
    //  this.searchableTags,
    this.privateOneToOne,
    this.opponentDetails,
    this.metaData,
    this.messagingDisabled,
    this.membersCount,
    this.lastReadAt,
    this.lastMessageSentAt,
    this.lastMessageDetails,
    this.isGroup,
    this.conversationType,
    this.conversationTitle,
    this.conversationImageUrl,
    this.conversationId,
    this.config,
    this.userIds,
  });

  int? updatedAt;
  int? unreadMessagesCount;
  //  List<String> searchableTags;
  List<String>? userIds;
  bool? privateOneToOne;
  UserDetails? opponentDetails;
  IsmChatMetaData? metaData;
  bool? messagingDisabled;
  int? membersCount;
  List<IsmChatLastReadAt>? lastReadAt;
  int? lastMessageSentAt;
  LastMessageDetails? lastMessageDetails;
  bool? isGroup;
  IsmChatConversationType? conversationType;
  String? conversationTitle;
  String? conversationImageUrl;
  String? conversationId;
  ConversationConfigModel? config;

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
  }) =>
      IsmChatConversationModel(
        updatedAt: updatedAt ?? this.updatedAt,
        unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
        // searchableTags: searchableTags ?? this.searchableTags,
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
        config: config ?? this.config,
      );

  Map<String, dynamic> toMap() => {
        'updatedAt': updatedAt,
        'unreadMessagesCount': unreadMessagesCount,
        // 'searchableTags': searchableTags,
        'privateOneToOne': privateOneToOne,
        'opponentDetails': opponentDetails!.toMap(),
        'metaData': metaData!.toMap(),
        'messagingDisabled': messagingDisabled,
        'lastReadAt': lastReadAt?.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
        'lastMessageDetails': lastMessageDetails,
        'isGroup': isGroup,
        'conversationType': conversationType,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl,
        'conversationId': conversationId,
        'config': config!.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ChatConversationModel(updatedAt: $updatedAt, unreadMessagesCount: $unreadMessagesCount, privateOneToOne: $privateOneToOne, opponentDetails: $opponentDetails, metaData: $metaData, messagingDisabled: $messagingDisabled, lastMessageSentAt: $lastMessageSentAt, lastMessageDetails: $lastMessageDetails, isGroup: $isGroup, conversationType: $conversationType, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, config: $config, lastReadAt: $lastReadAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsmChatConversationModel &&
        other.updatedAt == updatedAt &&
        other.unreadMessagesCount == unreadMessagesCount &&
        // listEquals(other.searchableTags, searchableTags) &&
        other.privateOneToOne == privateOneToOne &&
        other.opponentDetails == opponentDetails &&
        other.metaData == metaData &&
        other.messagingDisabled == messagingDisabled &&
        other.membersCount == membersCount &&
        listEquals(other.lastReadAt, lastReadAt) &&
        other.lastMessageDetails == lastMessageDetails &&
        other.lastMessageSentAt == lastMessageSentAt &&
        other.isGroup == isGroup &&
        other.conversationType == conversationType &&
        other.conversationTitle == conversationTitle &&
        other.conversationImageUrl == conversationImageUrl &&
        other.conversationId == conversationId &&
        other.config == config;
  }

  @override
  int get hashCode =>
      updatedAt.hashCode ^
      unreadMessagesCount.hashCode ^
      // searchableTags.hashCode ^
      privateOneToOne.hashCode ^
      opponentDetails.hashCode ^
      metaData.hashCode ^
      messagingDisabled.hashCode ^
      membersCount.hashCode ^
      lastReadAt.hashCode ^
      lastMessageDetails.hashCode ^
      lastMessageSentAt.hashCode ^
      isGroup.hashCode ^
      conversationType.hashCode ^
      conversationTitle.hashCode ^
      conversationImageUrl.hashCode ^
      conversationId.hashCode ^
      config.hashCode;
}
