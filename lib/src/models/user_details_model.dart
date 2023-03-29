import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserDetails {
  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserDetails.fromMap(Map<String, dynamic> map) => UserDetails(
        userProfileImageUrl: map['userProfileImageUrl'] as String,
        userName: map['userName'] as String,
        userIdentifier: map['userIdentifier'] as String,
        userId: map['userId'] != null ? map['userId'] as String : '',
        online: map['online'] as bool? ?? false,
        // metaData: ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        lastSeen: map['lastSeen'] as int? ?? 0,
        timestamp: map['timestamp'] as int? ?? 0,
        visibility:
            map['visibility'] != null ? map['visibility'] as bool : true,
        notification:
            map['notification'] != null ? map['notification'] as bool : null,
        language: map['language'] != null ? map['language'] as String : null,
      );

  UserDetails(
      {this.id = 0,
      required this.userProfileImageUrl,
      required this.userName,
      required this.userIdentifier,
      required this.userId,
      required this.online,
      // required this.metaData,
      required this.lastSeen,
      this.visibility,
      this.notification,
      this.language,
      this.timestamp});

  @Id()
  int id;
  final String userProfileImageUrl;
  final String userName;
  final String userIdentifier;
  final String userId;
  final bool online;
  // @Transient()
  // final ChatMetaData metaData;
  final int lastSeen;
  final bool? visibility;
  final bool? notification;
  final String? language;
  final int? timestamp;

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
  }) =>
      UserDetails(
        userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
        userName: userName ?? this.userName,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        userId: userId ?? this.userId,
        online: online ?? this.online,
        // metaData: metaData ?? this.metaData,
        lastSeen: lastSeen ?? this.lastSeen,
        visibility: visibility ?? this.visibility,
        notification: notification ?? this.notification,
        language: language ?? this.language,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userProfileImageUrl': userProfileImageUrl,
        'userName': userName,
        'userIdentifier': userIdentifier,
        'userId': userId,
        'online': online,
        // 'metaData': metaData.toMap(),
        'lastSeen': lastSeen,
        'visibility': visibility,
        'notification': notification,
        'language': language,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserDetails(userProfileImageUrl: $userProfileImageUrl, userName: $userName, userIdentifier: $userIdentifier, userId: $userId, online: $online, lastSeen: $lastSeen, visibility: $visibility, notification: $notification, language: $language)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.userProfileImageUrl == userProfileImageUrl &&
        other.userName == userName &&
        other.userIdentifier == userIdentifier &&
        other.userId == userId &&
        other.online == online &&
        // other.metaData == metaData &&
        other.lastSeen == lastSeen &&
        other.visibility == visibility &&
        other.notification == notification &&
        other.language == language;
  }

  @override
  int get hashCode =>
      userProfileImageUrl.hashCode ^
      userName.hashCode ^
      userIdentifier.hashCode ^
      userId.hashCode ^
      online.hashCode ^
      // metaData.hashCode ^
      lastSeen.hashCode ^
      visibility.hashCode ^
      notification.hashCode ^
      language.hashCode;
}
