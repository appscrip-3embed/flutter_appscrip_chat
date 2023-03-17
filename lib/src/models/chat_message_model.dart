import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:flutter/foundation.dart';

class ChatMessageModel {
  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) =>
      ChatMessageModel(
        body: map['body'] != null && (map['body'] as String).isNotEmpty
            ? ChatUtility.decodePayload(map['body'] as String)
            : '',
        action: map['action'] as String?,
        updatedAt: map['updatedAt'] as int? ?? 0,
        sentAt: map['sentAt'] as int? ?? 0,
        unreadMessagesCount: map['unreadMessagesCount'] as int? ?? 0,
        searchableTags: map['searchableTags'] != null
            ? List<String>.from(map['searchableTags'] as List<dynamic>)
            : [],
        privateOneToOne: map['privateOneToOne'] as bool? ?? false,
        showInConversation: map['showInConversation'] as bool? ?? true,
        readByAll: map['readByAll'] as bool? ?? false,
        senderInfo: map['senderInfo'] != null &&
                (map['senderInfo'] as Map<String, dynamic>).keys.isNotEmpty
            ? UserDetails.fromMap(map['senderInfo'] as Map<String, dynamic>)
            : null,
        metaData: map['metaData'] != null
            ? ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>)
            : null,
        messagingDisabled: map['messagingDisabled'] as bool? ?? false,
        membersCount: map['membersCount'] as int? ?? 0,
        lastReadAt: LastReadAt.fromNetworkMap(
            map['lastReadAt'] as Map<String, dynamic>? ?? {}),
        attachments: map['attachments'] != null
            ? (map['attachments'] as List<dynamic>)
                .map((e) => AttachmentModel.fromMap(e as Map<String, dynamic>))
                .toList()
            : null,
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        isGroup: map['isGroup'] as bool? ?? false,
        deliveredToAll: map['deliveredToAll'] as bool? ?? false,
        customType: map['customType'] != null
            ? CustomMessageType.fromMap(map['customType'])
            : null,
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
        adminCount: map['adminCount'] as int? ?? 0,
        messageType: MessageType.fromValue(map['messageType'] as int? ?? 0),
        mentionedUsers: map['mentionedUsers'],
      );

  ChatMessageModel({
    required this.body,
    this.action,
    required this.sentAt,
    required this.updatedAt,
    required this.unreadMessagesCount,
    required this.searchableTags,
    required this.privateOneToOne,
    required this.showInConversation,
    required this.readByAll,
    required this.senderInfo,
    required this.metaData,
    required this.messagingDisabled,
    required this.membersCount,
    required this.lastReadAt,
    this.attachments,
    required this.lastMessageSentAt,
    required this.isGroup,
    required this.deliveredToAll,
    this.customType,
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
    required this.adminCount,
    required this.messageType,
    this.mentionedUsers,
  });

  final String body;
  final String? action;
  final int sentAt;
  final int updatedAt;
  final int unreadMessagesCount;
  final List<String> searchableTags;
  final bool privateOneToOne;
  final bool showInConversation;
  final bool readByAll;
  final UserDetails? senderInfo;
  final ChatMetaData? metaData;
  final bool messagingDisabled;
  final int membersCount;
  final List<LastReadAt> lastReadAt;
  final List<AttachmentModel>? attachments;
  final int lastMessageSentAt;
  final bool isGroup;
  final bool deliveredToAll;
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
  final int adminCount;
  final MessageType messageType;
  final dynamic mentionedUsers;
  final CustomMessageType? customType;

  String get chatName => conversationTitle ?? senderInfo?.userName ?? '';

  ChatMessageModel copyWith({
    String? body,
    String? action,
    int? sentAt,
    int? updatedAt,
    int? unreadMessagesCount,
    List<String>? searchableTags,
    bool? privateOneToOne,
    bool? showInConversation,
    bool? readByAll,
    UserDetails? senderInfo,
    ChatMetaData? metaData,
    bool? messagingDisabled,
    int? membersCount,
    List<LastReadAt>? lastReadAt,
    List<AttachmentModel>? attachments,
    LastMessageDetails? lastMessageDetails,
    int? lastMessageSentAt,
    bool? isGroup,
    bool? deliveredToAll,
    CustomMessageType? customType,
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
        body: body ?? this.body,
        action: action ?? this.action,
        updatedAt: updatedAt ?? this.updatedAt,
        sentAt: sentAt ?? this.sentAt,
        unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
        searchableTags: searchableTags ?? this.searchableTags,
        privateOneToOne: privateOneToOne ?? this.privateOneToOne,
        showInConversation: showInConversation ?? this.showInConversation,
        readByAll: readByAll ?? this.readByAll,
        senderInfo: senderInfo ?? this.senderInfo,
        metaData: metaData ?? this.metaData,
        messagingDisabled: messagingDisabled ?? this.messagingDisabled,
        membersCount: membersCount ?? this.membersCount,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        attachments: attachments ?? this.attachments,
        lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
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
        adminCount: adminCount ?? this.adminCount,
        messageType: messageType ?? this.messageType,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      );

  Map<String, dynamic> toMap() => {
        'body': body,
        'action': action,
        'updatedAt': updatedAt,
        'sentAt': sentAt,
        'unreadMessagesCount': unreadMessagesCount,
        'searchableTags': searchableTags,
        'privateOneToOne': privateOneToOne,
        'showInConversation': showInConversation,
        'readByAll': readByAll,
        'senderInfo': senderInfo?.toMap(),
        'metaData': metaData?.toMap(),
        'messagingDisabled': messagingDisabled,
        'membersCount': membersCount,
        'lastReadAt': lastReadAt.map((x) => x.toMap()).toList(),
        'attachments': attachments?.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
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
        'adminCount': adminCount,
        'messageType': messageType.value,
        'mentionedUsers': mentionedUsers,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ChatMessageModel(body: $body, action: $action, updatedAt: $updatedAt, sentAt: $sentAt, unreadMessagesCount: $unreadMessagesCount, searchableTags: $searchableTags, privateOneToOne: $privateOneToOne, showInConversation: $showInConversation, readByAll: $readByAll, senderInfo: $senderInfo, metaData: $metaData, messagingDisabled: $messagingDisabled, membersCount: $membersCount, lastReadAt: $lastReadAt, attachments: $attachments, lastMessageSentAt: $lastMessageSentAt, isGroup: $isGroup, deliveredToAll: $deliveredToAll, customType: $customType, createdByUserName: $createdByUserName, createdByUserImageUrl: $createdByUserImageUrl, createdBy: $createdBy, createdAt: $createdAt, conversationType: $conversationType, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, parentMessageId: $parentMessageId, messageId: $messageId, deviceId: $deviceId, adminCount: $adminCount, messageType: $messageType, mentionedUsers: $mentionedUsers)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessageModel &&
        other.body == body &&
        other.action == action &&
        other.updatedAt == updatedAt &&
        other.sentAt == sentAt &&
        other.unreadMessagesCount == unreadMessagesCount &&
        listEquals(other.searchableTags, searchableTags) &&
        other.privateOneToOne == privateOneToOne &&
        other.showInConversation == showInConversation &&
        other.readByAll == readByAll &&
        other.senderInfo == senderInfo &&
        other.metaData == metaData &&
        other.messagingDisabled == messagingDisabled &&
        other.membersCount == membersCount &&
        listEquals(other.lastReadAt, lastReadAt) &&
        listEquals(other.attachments, attachments) &&
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
        other.messageType == messageType &&
        other.mentionedUsers == mentionedUsers &&
        other.adminCount == adminCount;
  }

  @override
  int get hashCode =>
      body.hashCode ^
      action.hashCode ^
      updatedAt.hashCode ^
      sentAt.hashCode ^
      unreadMessagesCount.hashCode ^
      searchableTags.hashCode ^
      privateOneToOne.hashCode ^
      showInConversation.hashCode ^
      readByAll.hashCode ^
      senderInfo.hashCode ^
      metaData.hashCode ^
      messagingDisabled.hashCode ^
      membersCount.hashCode ^
      lastReadAt.hashCode ^
      attachments.hashCode ^
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
      messageType.hashCode ^
      mentionedUsers.hashCode ^
      adminCount.hashCode;
}
