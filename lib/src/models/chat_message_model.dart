import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';

class ChatMessageModel {
  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    var model = ChatMessageModel(
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
          : map['senderId'] != null
              ? UserDetails(
                  userProfileImageUrl: map['senderProfileImageUrl'] as String,
                  userName: map['senderName'] as String,
                  userIdentifier: map['senderIdentifier'] as String,
                  userId: map['senderId'] as String,
                  online: false,
                  lastSeen: 0,
                )
              : null,
      metaData: map['metaData'] != null
          ? ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>)
          : null,
      messagingDisabled: map['messagingDisabled'] as bool? ?? false,
      membersCount: map['membersCount'] as int? ?? 0,
      lastReadAt: map['lastReadAt'].runtimeType == List
          ? List<LastReadAt>.from(map['lastReadAt'] as List<dynamic>)
          : LastReadAt.fromNetworkMap(
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
          : map['action'] != null
              ? CustomMessageType.fromAction(map['action'] as String)
              : null,
      createdByUserName: map['createdByUserName'] as String? ?? '',
      createdByUserImageUrl: map['createdByUserImageUrl'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
      conversationType: map['conversationType'] as int? ?? 0,
      conversationTitle: map['conversationTitle'] as String?,
      conversationImageUrl: map['conversationImageUrl'] as String?,
      conversationId: map['conversationId'] as String? ?? '',
      messageId: map['messageId'] as String? ?? '',
      deviceId: map['deviceId'] as String? ?? '',
      parentMessageId: map['parentMessageId'] as String? ?? '',
      adminCount: map['adminCount'] as int? ?? 0,
      messageType: MessageType.fromValue(map['messageType'] as int? ?? 0),
      sentByMe: true,
      mentionedUsers: map['mentionedUsers'],
      initiatorId: map['initiatorId'] as String?,
    );
    return model.copyWith(
      customType:
          model.customType != null && model.customType != CustomMessageType.text
              ? model.customType
              : CustomMessageType.withBody(model.body),
      sentByMe: model.senderInfo != null
          ? model.senderInfo!.userId == IsmChatConfig.communicationConfig.userId
          : true,
    );
  }

  factory ChatMessageModel.fromDate(int sentAt) => ChatMessageModel(
        body: sentAt.toMessageDateString(),
        action: '',
        updatedAt: 0,
        sentAt: sentAt,
        unreadMessagesCount: 0,
        searchableTags: [],
        privateOneToOne: false,
        showInConversation: true,
        readByAll: false,
        senderInfo: null,
        metaData: null,
        messagingDisabled: false,
        membersCount: 0,
        lastReadAt: [],
        attachments: null,
        lastMessageSentAt: 0,
        isGroup: false,
        deliveredToAll: false,
        customType: CustomMessageType.date,
        createdByUserName: '',
        createdByUserImageUrl: '',
        createdBy: '',
        conversationType: 0,
        conversationTitle: null,
        conversationImageUrl: null,
        conversationId: '',
        messageId: '',
        deviceId: '',
        parentMessageId: '',
        adminCount: 0,
        messageType: MessageType.normal,
        sentByMe: true,
        mentionedUsers: null,
      );

  ChatMessageModel({
    required this.body,
    this.action,
    required this.sentAt,
    this.updatedAt,
    this.unreadMessagesCount,
    this.searchableTags,
    this.privateOneToOne,
    this.showInConversation,
    this.readByAll,
    this.senderInfo,
    this.metaData,
    this.messagingDisabled,
    this.membersCount,
    this.lastReadAt,
    this.attachments,
    this.lastMessageSentAt,
    this.isGroup,
    this.deliveredToAll,
    required this.customType,
    this.createdByUserName,
    this.createdByUserImageUrl,
    this.createdBy,
    this.conversationType,
    this.conversationTitle,
    this.conversationImageUrl,
    this.conversationId,
    this.parentMessageId,
    this.messageId,
    this.deviceId,
    this.adminCount,
    this.messageType,
    required this.sentByMe,
    this.mentionedUsers,
    this.initiatorId,
  });

  String body;
  String? action;
  int sentAt;
  int? updatedAt;
  int? unreadMessagesCount;
  List<String>? searchableTags;
  bool? privateOneToOne;
  bool? showInConversation;
  bool? readByAll;
  UserDetails? senderInfo;
  ChatMetaData? metaData;
  bool? messagingDisabled;
  int? membersCount;
  List<LastReadAt>? lastReadAt;
  List<AttachmentModel>? attachments;
  int? lastMessageSentAt;
  bool? isGroup;
  bool? deliveredToAll;
  String? createdByUserName;
  String? createdByUserImageUrl;
  String? createdBy;
  int? conversationType;
  String? conversationTitle;
  String? conversationImageUrl;
  String? conversationId;
  String? parentMessageId;
  String? initiatorId;
  String? messageId;
  String? deviceId;
  int? adminCount;
  MessageType? messageType;
  dynamic mentionedUsers;
  CustomMessageType? customType;
  bool sentByMe;
  //  String initiatorId;

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
    int? conversationType,
    String? conversationTitle,
    String? conversationImageUrl,
    String? conversationId,
    String? parentMessageId,
    String? messageId,
    String? deviceId,
    ConversationConfigModel? config,
    int? adminCount,
    MessageType? messageType,
    bool? sentByMe,
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
        conversationType: conversationType ?? this.conversationType,
        conversationTitle: conversationTitle ?? this.conversationTitle,
        conversationImageUrl: conversationImageUrl ?? this.conversationImageUrl,
        conversationId: conversationId ?? this.conversationId,
        parentMessageId: parentMessageId ?? this.parentMessageId,
        messageId: messageId ?? this.messageId,
        deviceId: deviceId ?? this.deviceId,
        adminCount: adminCount ?? this.adminCount,
        messageType: messageType ?? this.messageType,
        sentByMe: sentByMe ?? this.sentByMe,
        mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      );

  Map<String, dynamic> toMap() => {
        'body': ChatUtility.encodePayload(body),
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
        'lastReadAt': lastReadAt?.map((x) => x.toMap()).toList(),
        'attachments': attachments?.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
        'isGroup': isGroup,
        'deliveredToAll': deliveredToAll,
        'customType': customType?.value,
        'createdByUserName': createdByUserName,
        'createdByUserImageUrl': createdByUserImageUrl,
        'createdBy': createdBy,
        'conversationType': conversationType,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl,
        'conversationId': conversationId,
        'parentMessageId': parentMessageId,
        'messageId': messageId,
        'deviceId': deviceId,
        'adminCount': adminCount,
        'messageType': messageType?.value,
        'sentByMe': sentByMe,
        'mentionedUsers': mentionedUsers,
        'initiatorId': initiatorId,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ChatMessageModel(body: $body, action: $action, updatedAt: $updatedAt, sentAt: $sentAt, unreadMessagesCount: $unreadMessagesCount, searchableTags: $searchableTags, privateOneToOne: $privateOneToOne, showInConversation: $showInConversation, readByAll: $readByAll, senderInfo: $senderInfo, metaData: $metaData, messagingDisabled: $messagingDisabled, membersCount: $membersCount, lastReadAt: $lastReadAt, attachments: $attachments, lastMessageSentAt: $lastMessageSentAt, isGroup: $isGroup, deliveredToAll: $deliveredToAll, customType: $customType, createdByUserName: $createdByUserName, createdByUserImageUrl: $createdByUserImageUrl, createdBy: $createdBy, conversationType: $conversationType, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, parentMessageId: $parentMessageId, messageId: $messageId, deviceId: $deviceId, adminCount: $adminCount, messageType: $messageType, sentByMe: $sentByMe, mentionedUsers: $mentionedUsers)';

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
        other.conversationType == conversationType &&
        other.conversationTitle == conversationTitle &&
        other.conversationImageUrl == conversationImageUrl &&
        other.conversationId == conversationId &&
        other.parentMessageId == parentMessageId &&
        other.messageId == messageId &&
        other.deviceId == deviceId &&
        other.messageType == messageType &&
        other.mentionedUsers == mentionedUsers &&
        other.sentByMe == sentByMe &&
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
      conversationType.hashCode ^
      conversationTitle.hashCode ^
      conversationImageUrl.hashCode ^
      conversationId.hashCode ^
      parentMessageId.hashCode ^
      messageId.hashCode ^
      deviceId.hashCode ^
      messageType.hashCode ^
      mentionedUsers.hashCode ^
      sentByMe.hashCode ^
      adminCount.hashCode;
}
