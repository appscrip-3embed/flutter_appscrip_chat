import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';

class UserDetails {
  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserDetails.fromMap(Map<String, dynamic> map) => UserDetails(
        userProfileImageUrl: map['userProfileImageUrl'] as String,
        userName: map['userName'] as String,
        userIdentifier: map['userIdentifier'] as String,
        userId: map['userId'] as String,
        online: map['online'] as bool,
        metaData: ChatMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        lastSeen: map['lastSeen'] as int,
      );

  const UserDetails({
    required this.userProfileImageUrl,
    required this.userName,
    required this.userIdentifier,
    required this.userId,
    required this.online,
    required this.metaData,
    required this.lastSeen,
  });
  final String userProfileImageUrl;
  final String userName;
  final String userIdentifier;
  final String userId;
  final bool online;
  final ChatMetaData metaData;
  final int lastSeen;

  UserDetails copyWith({
    String? userProfileImageUrl,
    String? userName,
    String? userIdentifier,
    String? userId,
    bool? online,
    ChatMetaData? metaData,
    int? lastSeen,
  }) =>
      UserDetails(
        userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
        userName: userName ?? this.userName,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        userId: userId ?? this.userId,
        online: online ?? this.online,
        metaData: metaData ?? this.metaData,
        lastSeen: lastSeen ?? this.lastSeen,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userProfileImageUrl': userProfileImageUrl,
        'userName': userName,
        'userIdentifier': userIdentifier,
        'userId': userId,
        'online': online,
        'metaData': metaData.toMap(),
        'lastSeen': lastSeen,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserDetails(userProfileImageUrl: $userProfileImageUrl, userName: $userName, userIdentifier: $userIdentifier, userId: $userId, online: $online, metaData: $metaData, lastSeen: $lastSeen)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.userProfileImageUrl == userProfileImageUrl &&
        other.userName == userName &&
        other.userIdentifier == userIdentifier &&
        other.userId == userId &&
        other.online == online &&
        other.metaData == metaData &&
        other.lastSeen == lastSeen;
  }

  @override
  int get hashCode =>
      userProfileImageUrl.hashCode ^
      userName.hashCode ^
      userIdentifier.hashCode ^
      userId.hashCode ^
      online.hashCode ^
      metaData.hashCode ^
      lastSeen.hashCode;
}
