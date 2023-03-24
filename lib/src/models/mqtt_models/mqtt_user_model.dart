import 'dart:convert';

class MqttUserModel {
  factory MqttUserModel.fromJson(String source) =>
      MqttUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MqttUserModel.fromMap(Map<String, dynamic> map) => MqttUserModel(
        userId: (map['userId']) as String,
        userName: map['userName'] as String,
        profileImageUrl: map['userProfileImageUrl'] != null
            ? map['userProfileImageUrl'] as String
            : null,
        userIdentifier: map['userIdentifier'] != null
            ? map['userIdentifier'] as String
            : null,
      );

  const MqttUserModel({
    required this.userId,
    required this.userName,
    this.profileImageUrl,
    this.userIdentifier,
  });
  final String userId;
  final String userName;
  final String? profileImageUrl;
  final String? userIdentifier;

  MqttUserModel copyWith({
    String? userId,
    String? userName,
    String? profileImageUrl,
    String? userIdentifier,
  }) =>
      MqttUserModel(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        userIdentifier: userIdentifier ?? this.userIdentifier,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'userName': userName,
        'profileImageUrl': profileImageUrl,
        'userIdentifier': userIdentifier,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'MqttUserModel(id: $userId, name: $userName, profileImageUrl: $profileImageUrl, identifier: $userIdentifier)';

  @override
  bool operator ==(covariant MqttUserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.profileImageUrl == profileImageUrl &&
        other.userIdentifier == userIdentifier;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      userName.hashCode ^
      profileImageUrl.hashCode ^
      userIdentifier.hashCode;
}
