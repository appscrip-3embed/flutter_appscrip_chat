import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserDetails {
  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserDetails.fromMap(Map<String, dynamic> map) => UserDetails(
      userProfileImageUrl: map['userProfileImageUrl'] as String? ?? '',
      userName: map['userName'] as String? ?? '',
      userIdentifier: map['userIdentifier'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      online: map['online'] as bool? ?? false,
      memberName: map['memberName'] as String? ?? '',
      memberId : map['memberId'] as String? ?? '',
      metaData: map['metaData'] == null
          ? IsmChatMetaData()
          : IsmChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
      lastSeen: map['lastSeen'] as int? ?? 0,
      timestamp: map['timestamp'] as int? ?? 0,
      visibility: map['visibility'] != null ? map['visibility'] as bool : true,
      notification:
          map['notification'] != null ? map['notification'] as bool : null,
      language: map['language'] != null ? map['language'] as String : null,
      order: map['order'] != null ? map['order'] as int : null,
      wordCount: map['wordCount'] != null ? map['wordCount'] as int : null,
      isAdmin: map['isAdmin'] as bool? ?? false);

  UserDetails({
    this.id = 0,
    required this.userProfileImageUrl,
    required this.userName,
    required this.userIdentifier,
    required this.userId,
    required this.online,
    this.metaData,
    required this.lastSeen,
    this.visibility,
    this.notification,
    this.language,
    this.timestamp,
    this.memberName,
    this.memberId,
    this.order,
    this.wordCount,
    this.isAdmin = false,
  });

  @Id()
  int id;
  final String userProfileImageUrl;
  final String userName;
  final String userIdentifier;
  final String userId;
  final bool online;
  @Transient()
  IsmChatMetaData? metaData;
  final int lastSeen;
  final bool? visibility;
  final bool? notification;
  final String? language;
  final int? timestamp;
  final String? memberName;
  final String? memberId;

  final bool isAdmin;
  final int? wordCount;
  final int? order;

  String get userDBMetadata => metaData?.toJson() ?? '';

  set userDBMetadata(String value) {
    metaData = IsmChatMetaData.fromJson(value);
  }

  String get profileUrl => metaData?.profilePic ?? userProfileImageUrl;

  UserDetails copyWith({
    String? userProfileImageUrl,
    String? userName,
    String? userIdentifier,
    String? userId,
    bool? online,
    IsmChatMetaData? metaData,
    int? lastSeen,
    bool? visibility,
    bool? notification,
    String? language,
    String? memberName,
    String? memberId,
    bool? isAdmin,
    int? wordCount,
    int? order,
  }) =>
      UserDetails(
          userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
          userName: userName ?? this.userName,
          userIdentifier: userIdentifier ?? this.userIdentifier,
          userId: userId ?? this.userId,
          online: online ?? this.online,
          metaData: metaData ?? this.metaData,
          lastSeen: lastSeen ?? this.lastSeen,
          visibility: visibility ?? this.visibility,
          notification: notification ?? this.notification,
          language: language ?? this.language,
          memberName: memberName ?? this.memberName,
          order: order ?? this.order,
          wordCount: wordCount ?? this.wordCount,
          isAdmin: isAdmin ?? this.isAdmin,
          memberId: memberId ?? this.memberId);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userProfileImageUrl': userProfileImageUrl,
        'userName': userName,
        'userIdentifier': userIdentifier,
        'userId': userId,
        'online': online,
        'metaData': metaData?.toMap(),
        'lastSeen': lastSeen,
        'visibility': visibility,
        'notification': notification,
        'language': language,
        'isAdmin': isAdmin,
        'memberName': memberName,
        'order': order,
        'wordCount': wordCount,
        'memberId' : memberId
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserDetails(userProfileImageUrl: $userProfileImageUrl, userName: $userName, userIdentifier: $userIdentifier, userId: $userId, online: $online, lastSeen: $lastSeen, visibility: $visibility, notification: $notification, language: $language, isAdmin : $isAdmin, memberName : $memberName, order : $order, wordCount : $wordCount, memberId : $memberId)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.userProfileImageUrl == userProfileImageUrl &&
        other.userName == userName &&
        other.userIdentifier == userIdentifier &&
        other.userId == userId &&
        other.online == online &&
        other.metaData == metaData &&
        other.lastSeen == lastSeen &&
        other.visibility == visibility &&
        other.notification == notification &&
        other.language == language &&
        other.memberName == memberName &&
        other.isAdmin == isAdmin &&
        other.wordCount == wordCount && 
        other.memberId == memberId &&
        other.order == order;
  }

  @override
  int get hashCode =>
      userProfileImageUrl.hashCode ^
      userName.hashCode ^
      userIdentifier.hashCode ^
      userId.hashCode ^
      online.hashCode ^
      metaData.hashCode ^
      lastSeen.hashCode ^
      visibility.hashCode ^
      notification.hashCode ^
      isAdmin.hashCode ^
      memberName.hashCode ^
      wordCount.hashCode ^
      order.hashCode ^
      language.hashCode ^
      memberId.hashCode;
}
