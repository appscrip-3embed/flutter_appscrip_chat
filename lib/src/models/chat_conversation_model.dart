import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';

class ChatConversationModel {
  factory ChatConversationModel.fromJson(String source) =>
      ChatConversationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  factory ChatConversationModel.fromMap(Map<String, dynamic> map) =>
      ChatConversationModel(
        updatedAt: map['updatedAt'] as int? ?? 0,
        unreadMessagesCount: map['unreadMessagesCount'] as int? ?? 0,
        // searchableTags:
        //     List<String>.from(map['searchableTags'] as List<dynamic>),
        privateOneToOne: map['privateOneToOne'] as bool? ?? false,
        opponentDetails:
            UserDetails.fromMap(map['opponentDetails'] as Map<String, dynamic>),
        metaData: ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        messagingDisabled: map['messagingDisabled'] as bool? ?? false,
        membersCount: map['membersCount'] as int? ?? 0,
        // lastReadAt: LastReadAt.fromNetworkMap(
        //     map['lastReadAt'] as Map<String, dynamic>? ?? {}),
        lastMessageSentAt: map['lastMessageSentAt'] as int? ?? 0,
        lastMessageDetails: LastMessageDetails.fromMap(
            map['lastMessageDetails'] as Map<String, dynamic>? ?? {}),
        isGroup: map['isGroup'] as bool? ?? false,
        customType: map['customType'],
        // createdByUserName: map['createdByUserName'] as String? ?? '',
        // createdByUserImageUrl: map['createdByUserImageUrl'] as String? ?? '',
        // createdBy: map['createdBy'] as String? ?? '',
        // createdAt: map['createdAt'] as int? ?? 0,
        conversationType:
            ConversationType.fromValue(map['conversationType'] as int? ?? 1),
        conversationTitle: map['conversationTitle'] as String?,
        conversationImageUrl: map['conversationImageUrl'] as String?,
        conversationId: map['conversationId'] as String? ?? '',
        config:
            ConversationConfigModel.fromMap(map['config'] as Map<String, dynamic>),
        // adminCount: map['adminCount'] as int? ?? 0,
      );

  ChatConversationModel({
     this.updatedAt,
     this.unreadMessagesCount,
    //  this.searchableTags,
     this.privateOneToOne,
     this.opponentDetails,
     this.metaData,
     this.messagingDisabled,
     this.membersCount,
    //  this.lastReadAt,
     this.lastMessageSentAt,
     this.lastMessageDetails,
     this.isGroup,
     this.customType,
    //  this.createdByUserName,
    //  this.createdByUserImageUrl,
    //  this.createdBy,
    //  this.createdAt,
     this.conversationType,
    this.conversationTitle,
    this.conversationImageUrl,
     this.conversationId,
     this.config,
    //  this.adminCount,
  });

   int? updatedAt;
   int? unreadMessagesCount;
  //  List<String> searchableTags;
   bool? privateOneToOne;
   UserDetails? opponentDetails;
   ChatMetaData? metaData;
   bool? messagingDisabled;
   int? membersCount;
  //  List<LastReadAt> lastReadAt;
   int? lastMessageSentAt;
   LastMessageDetails? lastMessageDetails;
   bool? isGroup;
   dynamic customType;
  //  String createdByUserName;
  //  String createdByUserImageUrl;
  //  String createdBy;
  //  int createdAt;
   ConversationType? conversationType;
   String? conversationTitle;
   String? conversationImageUrl;
   String? conversationId;
   ConversationConfigModel? config;
  //  int adminCount;

  String get chatName => conversationTitle ?? opponentDetails?.userName ?? '';

  ChatConversationModel copyWith({
    int? updatedAt,
    int? unreadMessagesCount,
    List<String>? searchableTags,
    bool? privateOneToOne,
    UserDetails? opponentDetails,
    ChatMetaData? metaData,
    bool? messagingDisabled,
    int? membersCount,
    List<LastReadAt>? lastReadAt,
    LastMessageDetails? lastMessageDetails,
    int? lastMessageSentAt,
    bool? isGroup,
    dynamic customType,
    String? createdByUserName,
    String? createdByUserImageUrl,
    String? createdBy,
    int? createdAt,
    ConversationType? conversationType,
    String? conversationTitle,
    String? conversationImageUrl,
    String? conversationId,
    ConversationConfigModel? config,
    int? adminCount,
  }) =>
      ChatConversationModel(
        updatedAt: updatedAt ?? this.updatedAt,
        unreadMessagesCount: unreadMessagesCount ?? this.unreadMessagesCount,
        // searchableTags: searchableTags ?? this.searchableTags,
        privateOneToOne: privateOneToOne ?? this.privateOneToOne,
        opponentDetails: opponentDetails ?? this.opponentDetails,
        metaData: metaData ?? this.metaData,
        messagingDisabled: messagingDisabled ?? this.messagingDisabled,
        membersCount: membersCount ?? this.membersCount,
        // lastReadAt: lastReadAt ?? this.lastReadAt,
        lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
        lastMessageDetails: lastMessageDetails ?? this.lastMessageDetails,
        isGroup: isGroup ?? this.isGroup,
        customType: customType ?? this.customType,
        // createdByUserName: createdByUserName ?? this.createdByUserName,
        // createdByUserImageUrl:
        //     createdByUserImageUrl ?? this.createdByUserImageUrl,
        // createdBy: createdBy ?? this.createdBy,
        // createdAt: createdAt ?? this.createdAt,
        conversationType: conversationType ?? this.conversationType,
        conversationTitle: conversationTitle ?? this.conversationTitle,
        conversationImageUrl: conversationImageUrl ?? this.conversationImageUrl,
        conversationId: conversationId ?? this.conversationId,
        config: config ?? this.config,
        // adminCount: adminCount ?? this.adminCount,
      );

  Map<String, dynamic> toMap() => {
        'updatedAt': updatedAt,
        'unreadMessagesCount': unreadMessagesCount,
        // 'searchableTags': searchableTags,
        'privateOneToOne': privateOneToOne,
        'opponentDetails': opponentDetails!.toMap(),
        'metaData': metaData!.toMap(),
        'messagingDisabled': messagingDisabled,
        // 'membersCount': membersCount,
        // 'lastReadAt': lastReadAt.map((x) => x.toMap()).toList(),
        'lastMessageSentAt': lastMessageSentAt,
        'lastMessageDetails': lastMessageDetails,
        'isGroup': isGroup,
        'customType': customType,
        // 'createdByUserName': createdByUserName,
        // 'createdByUserImageUrl': createdByUserImageUrl,
        // 'createdBy': createdBy,
        // 'createdAt': createdAt,
        'conversationType': conversationType,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl,
        'conversationId': conversationId,
        'config': config!.toMap(),
        // 'adminCount': adminCount,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ChatConversationModel(updatedAt: $updatedAt, unreadMessagesCount: $unreadMessagesCount, privateOneToOne: $privateOneToOne, opponentDetails: $opponentDetails, metaData: $metaData, messagingDisabled: $messagingDisabled, lastMessageSentAt: $lastMessageSentAt, lastMessageDetails: $lastMessageDetails, isGroup: $isGroup, customType: $customType, conversationType: $conversationType, conversationTitle: $conversationTitle, conversationImageUrl: $conversationImageUrl, conversationId: $conversationId, config: $config)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatConversationModel &&
        other.updatedAt == updatedAt &&
        other.unreadMessagesCount == unreadMessagesCount &&
        // listEquals(other.searchableTags, searchableTags) &&
        other.privateOneToOne == privateOneToOne &&
        other.opponentDetails == opponentDetails &&
        other.metaData == metaData &&
        other.messagingDisabled == messagingDisabled &&
        // other.membersCount == membersCount &&
        // listEquals(other.lastReadAt, lastReadAt) &&
        other.lastMessageDetails == lastMessageDetails &&
        other.lastMessageSentAt == lastMessageSentAt &&
        other.isGroup == isGroup &&
        other.customType == customType &&
        // other.createdByUserName == createdByUserName &&
        // other.createdByUserImageUrl == createdByUserImageUrl &&
        // other.createdBy == createdBy &&
        // other.createdAt == createdAt &&
        other.conversationType == conversationType &&
        other.conversationTitle == conversationTitle &&
        other.conversationImageUrl == conversationImageUrl &&
        other.conversationId == conversationId &&
        // other.adminCount == adminCount &&
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
      // membersCount.hashCode ^
      // lastReadAt.hashCode ^
      lastMessageDetails.hashCode ^
      lastMessageSentAt.hashCode ^
      isGroup.hashCode ^
      customType.hashCode ^
      // createdByUserName.hashCode ^
      // createdByUserImageUrl.hashCode ^
      // createdBy.hashCode ^
      // createdAt.hashCode ^
      conversationType.hashCode ^
      conversationTitle.hashCode ^
      conversationImageUrl.hashCode ^
      conversationId.hashCode ^
      // adminCount.hashCode ^
      config.hashCode;
}
