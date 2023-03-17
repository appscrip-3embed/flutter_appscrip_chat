import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:flutter/foundation.dart';

class ChatMessageModel {
  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) =>
      ChatMessageModel(
        updatedAt: map['updatedAt'] as int? ?? 0,
        sentAt: map['sentAt'] as int? ?? 0,
        unreadMessagesCount: map['unreadMessagesCount'] as int? ?? 0,
        searchableTags:
            List<String>.from(map['searchableTags'] as List<dynamic>),
        privateOneToOne: map['privateOneToOne'] as bool? ?? false,
        showInConversation: map['showInConversation'] as bool? ?? true,
        readByAll: map['readByAll'] as bool? ?? false,
        opponentDetails:
            UserDetails.fromMap(map['opponentDetails'] as Map<String, dynamic>),
        metaData: ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        messagingDisabled: map['messagingDisabled'] as bool? ?? false,
        membersCount: map['membersCount'] as int? ?? 0,
        lastReadAt: LastReadAt.fromNetworkMap(
            map['lastReadAt'] as Map<String, dynamic>? ?? {}),
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        lastMessageDetails: LastMessageDetails.fromMap(
            map['lastMessageDetails'] as Map<String, dynamic>? ?? {}),
        isGroup: map['isGroup'] as bool? ?? false,
        deliveredToAll: map['deliveredToAll'] as bool? ?? false,
        customType: map['customType'],
        createdByUserName: map['createdByUserName'] as String? ?? '',
        createdByUserImageUrl: map['createdByUserImageUrl'] as String? ?? '',
        createdBy: map['createdBy'] as String? ?? '',
        createdAt: map['createdAt'] as int? ?? 0,
        conversationType: map['conversationType'] as int? ?? 0,
        conversationTitle: map['conversationTitle'] as String?,
        conversationImageUrl: map['conversationImageUrl'] as String?,
        conversationId: map['conversationId'] as String? ?? '',
        messageId: map['messageId'] as String? ?? '',
        deviceId: map['deviceId'] as String? ?? '',
        parentMessageId: map['parentMessageId'] as String? ?? '',
        config:
            ConversationConfig.fromMap(map['config'] as Map<String, dynamic>),
        adminCount: map['adminCount'] as int? ?? 0,
        messageType: MessageType.fromValue(map['messageType'] as int? ?? 0),
        mentionedUsers: map['mentionedUsers'],
      );

  ChatMessageModel({
    required this.sentAt,
    required this.updatedAt,
    required this.unreadMessagesCount,
    required this.searchableTags,
    required this.privateOneToOne,
    required this.showInConversation,
    required this.readByAll,
    required this.opponentDetails,
    required this.metaData,
    required this.messagingDisabled,
    required this.membersCount,
    required this.lastReadAt,
    required this.lastMessageSentAt,
    required this.lastMessageDetails,
    required this.isGroup,
    required this.deliveredToAll,
    required this.customType,
    required this.createdByUserName,
    required this.createdByUserImageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.conversationType,
    this.conversationTitle,
    this.conversationImageUrl,
    required this.conversationId,
    required this.parentMessageId,
    required this.messageId,
    required this.deviceId,
    required this.config,
    required this.adminCount,
    required this.messageType,
    this.mentionedUsers,
  });

  final int sentAt;
  final int updatedAt;
  final int unreadMessagesCount;
  final List<String> searchableTags;
  final bool privateOneToOne;
  final bool showInConversation;
  final bool readByAll;
  final UserDetails opponentDetails;
  final ChatMetaData metaData;
  final bool messagingDisabled;
  final int membersCount;
  final List<LastReadAt> lastReadAt;
  final int lastMessageSentAt;
  final LastMessageDetails lastMessageDetails;
  final bool isGroup;
  final bool deliveredToAll;
  final dynamic customType;
  final String createdByUserName;
  final String createdByUserImageUrl;
  final String createdBy;
  final int createdAt;
  final int conversationType;
  final String? conversationTitle;
  final String? conversationImageUrl;
  final String conversationId;
  final String parentMessageId;
  final String messageId;
  final String deviceId;
  final ConversationConfig config;
  final int adminCount;
  final MessageType messageType;
  final dynamic mentionedUsers;

  String get chatName => conversationTitle ?? opponentDetails.userName;

  ChatMessageModel copyWith({
    int? sentAt,
    int? updatedAt,
    int? unreadMessagesCount,
    List<String>? searchableTags,
    bool? privateOneToOne,
    bool? showInConversation,
    bool? readByAll,
    UserDetails? opponentDetails,
    ChatMetaData? metaData,
    bool? messagingDisabled,
    int? membersCount,
    List<LastReadAt>? lastReadAt,
    LastMessageDetails? lastMessageDetails,
    int? lastMessageSentAt,
    bool? isGroup,
    bool? deliveredToAll,
    dynamic customType,
    String? createdByUserName,
    String? createdByUserImageUrl,
    String? createdBy,
    int? createdAt,
    int? conversationType,
    String? conversationTitle,
    String? conversationImageUrl,
    String? conversationId,
    String? parentMessageId,
    String? messageId,
    String? deviceId,
    ConversationConfig? config,
    int? adminCount,
    MessageType? messageType,
    dynamic mentionedUsers,
  }) =>
      ChatMessageModel(
        updatedAt: updatedAt ?? this.updatedAt,
        sentAt: sentAt ?? this.sentAt,
        unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
        searchableTags: searchableTags ?? this.searchableTags,
        privateOneToOne: privateOneToOne ?? this.privateOneToOne,
        showInConversation: showInConversation ?? this.showInConversation,
        readByAll: readByAll ?? this.readByAll,
        opponentDetails: opponentDetails ?? this.opponentDetails,
        metaData: metaData ?? this.metaData,
        messagingDisabled: messagingDisabled ?? this.messagingDisabled,
        membersCount: membersCount ?? this.membersCount,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
        lastMessageDetails: lastMessageDetails ?? this.lastMessageDetails,
        isGroup: isGroup ?? this.isGroup,
        deliveredToAll: deliveredToAll ?? this.deliveredToAll,
        customType: customType ?? this.customType,
        createdByUserName: createdByUserName ?? this.createdByUserName,
        createdByUserImageUrl:
            createdByUserImageUrl ?? this.createdByUserImageUrl,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        conversationType: conversationType ?? this.conversationType,
        conversationTitle: conversationTitle ?? this.conversationTitle,
        conversationImageUrl: conversationImageUrl ?? this.conversationImageUrl,
        conversationId: conversationId ?? this.conversationId,
        parentMessageId: parentMessageId ?? this.parentMessageId,
        messageId: messageId ?? this.messageId,
        deviceId: deviceId ?? this.deviceId,
        config: config ?? this.config,
        adminCount: adminCount ?? this.adminCount,
        messageType: messageType ?? this.messageType,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      );

  Map<String, dynamic> toMap() => {
        'updatedAt': updatedAt,
        'sentAt': sentAt,
        'unreadMessagesCount': unreadMessagesCount,
        'searchableTags': searchableTags,
        'privateOneToOne': privateOneToOne,
        'showInConversation': showInConversation,
        'readByAll': readByAll,
        'opponentDetails': opponentDetails.toMap(),
        'metaData': metaData.toMap(),
        'messagingDisabled': messagingDisabled,
        'membersCount': membersCount,
        'lastReadAt': lastReadAt.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
        'lastMessageDetails': lastMessageDetails,
        'isGroup': isGroup,
        'deliveredToAll': deliveredToAll,
        'customType': customType,
        'createdByUserName': createdByUserName,
        'createdByUserImageUrl': createdByUserImageUrl,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'conversationType': conversationType,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl,
        'conversationId': conversationId,
        'parentMessageId': parentMessageId,
        'messageId': messageId,
        'deviceId': deviceId,
        'config': config.toMap(),
        'adminCount': adminCount,
        'messageType': messageType.value,
        'mentionedUsers': mentionedUsers,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ChatMessageModel(updatedAt: $updatedAt, sentAt: $sentAt, unreadMessagesCount: $unreadMessagesCount, searchableTags: $searchableTags, privateOneToOne: $privateOneToOne, showInConversation: $showInConversation, readByAll: $readByAll, opponentDetails: $opponentDetails, metaData: $metaData, messagingDisabled: $messagingDisabled, membersCount: $membersCount, lastReadAt: $lastReadAt, lastMessageSentAt: $lastMessageSentAt, lastMessageDetails: $lastMessageDetails, isGroup: $isGroup, deliveredToAll: $deliveredToAll, customType: $customType, createdByUserName: $createdByUserName, createdByUserImageUrl: $createdByUserImageUrl, createdBy: $createdBy, createdAt: $createdAt, conversationType: $conversationType, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, parentMessageId: $parentMessageId, messageId: $messageId, deviceId: $deviceId, config: $config, adminCount: $adminCount, messageType: $messageType, mentionedUsers: $mentionedUsers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessageModel &&
        other.updatedAt == updatedAt &&
        other.sentAt == sentAt &&
        other.unreadMessagesCount == unreadMessagesCount &&
        listEquals(other.searchableTags, searchableTags) &&
        other.privateOneToOne == privateOneToOne &&
        other.showInConversation == showInConversation &&
        other.readByAll == readByAll &&
        other.opponentDetails == opponentDetails &&
        other.metaData == metaData &&
        other.messagingDisabled == messagingDisabled &&
        other.membersCount == membersCount &&
        listEquals(other.lastReadAt, lastReadAt) &&
        other.lastMessageDetails == lastMessageDetails &&
        other.lastMessageSentAt == lastMessageSentAt &&
        other.isGroup == isGroup &&
        other.deliveredToAll == deliveredToAll &&
        other.customType == customType &&
        other.createdByUserName == createdByUserName &&
        other.createdByUserImageUrl == createdByUserImageUrl &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.conversationType == conversationType &&
        other.conversationTitle == conversationTitle &&
        other.conversationImageUrl == conversationImageUrl &&
        other.conversationId == conversationId &&
        other.parentMessageId == parentMessageId &&
        other.messageId == messageId &&
        other.deviceId == deviceId &&
        other.config == config &&
        other.messageType == messageType &&
        other.mentionedUsers == mentionedUsers &&
        other.adminCount == adminCount;
  }

  @override
  int get hashCode =>
      updatedAt.hashCode ^
      sentAt.hashCode ^
      unreadMessagesCount.hashCode ^
      searchableTags.hashCode ^
      privateOneToOne.hashCode ^
      showInConversation.hashCode ^
      readByAll.hashCode ^
      opponentDetails.hashCode ^
      metaData.hashCode ^
      messagingDisabled.hashCode ^
      membersCount.hashCode ^
      lastReadAt.hashCode ^
      lastMessageDetails.hashCode ^
      lastMessageSentAt.hashCode ^
      isGroup.hashCode ^
      deliveredToAll.hashCode ^
      customType.hashCode ^
      createdByUserName.hashCode ^
      createdByUserImageUrl.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      conversationType.hashCode ^
      conversationTitle.hashCode ^
      conversationImageUrl.hashCode ^
      conversationId.hashCode ^
      parentMessageId.hashCode ^
      messageId.hashCode ^
      deviceId.hashCode ^
      config.hashCode ^
      messageType.hashCode ^
      mentionedUsers.hashCode ^
      adminCount.hashCode;
}
