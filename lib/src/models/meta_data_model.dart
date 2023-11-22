import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';

class IsmChatMetaData {
  IsmChatMetaData({
    this.country,
    this.parentMessageBody,
    this.locationAddress,
    this.locationSubAddress,
    this.profilePic,
    this.lastName,
    this.firstName,
    this.parentMessageInitiator,
    this.customType,
    this.assetList,
    this.duration,
    this.replayMessageCustomType,
  });

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
        replayMessageCustomType: map['replayMessageCustomType'] != null
            ? IsmChatCustomMessageType.fromString(
                map['replayMessageCustomType'])
            : null,
        country: map['country'] as String? ?? '',
        parentMessageBody: map['parentMessageBody'] as String? ?? '',
        locationAddress: map['locationAddress'] as String? ?? '',
        locationSubAddress: map['locationSubAddress'] as String? ?? '',
        profilePic: map['profilePic'] as String? ?? '',
        parentMessageInitiator: map['parentMessageInitiator'] as bool? ?? false,
        firstName: map['firstName'] as String? ?? '',
        lastName: map['lastName'] as String? ?? '',
        customType: map['customType'].runtimeType == String
            ? {'${map['customType']}': map['customType']}
            : map['customType'] as Map<String, dynamic>? ?? {},
        assetList: map['assetList'] == null
            ? []
            : List<Map<String, IsmChatBackgroundModel>>.from(
                map['assetList'].map(
                  (x) => Map.from(x).map(
                    (k, v) => MapEntry<String, IsmChatBackgroundModel>(
                      k,
                      v.runtimeType == String
                          ? IsmChatBackgroundModel.fromJson(v)
                          : IsmChatBackgroundModel.fromMap(v),
                    ),
                  ),
                ),
              ).toList(),
        duration: Duration(seconds: map['duration'] as int? ?? 0),
      );

  factory IsmChatMetaData.fromJson(String? source) {
    if (source?.isEmpty == true || source == null) {
      return IsmChatMetaData();
    }
    return IsmChatMetaData.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
  final String? country;
  final String? parentMessageBody;
  final String? locationAddress;
  final String? locationSubAddress;
  final String? profilePic;
  final String? lastName;
  final String? firstName;
  final bool? parentMessageInitiator;
  final Map<String, dynamic>? customType;
  final List<Map<String, IsmChatBackgroundModel>>? assetList;
  final Duration? duration;
  final String? captionMessage;
  final IsmChatCustomMessageType? replayMessageCustomType;

  IsmChatMetaData copyWith({
    String? country,
    String? parentMessageBody,
    String? locationAddress,
    String? locationSubAddress,
    String? profilePic,
    String? lastName,
    String? firstName,
    bool? parentMessageInitiator,
    Map<String, dynamic>? customType,
    List<Map<String, IsmChatBackgroundModel>>? assetList,
    Duration? duration,
    String? captionMessage,
    IsmChatCustomMessageType? replayMessageCustomType,
  }) =>
      IsmChatMetaData(
        country: country ?? this.country,
        parentMessageBody: parentMessageBody ?? this.parentMessageBody,
        locationAddress: locationAddress ?? this.locationAddress,
        locationSubAddress: locationSubAddress ?? this.locationSubAddress,
        profilePic: profilePic ?? this.profilePic,
        lastName: lastName ?? this.lastName,
        firstName: firstName ?? this.firstName,
        parentMessageInitiator:
            parentMessageInitiator ?? this.parentMessageInitiator,
        customType: customType ?? this.customType,
        assetList: assetList ?? this.assetList,
        duration: duration ?? this.duration,
        captionMessage: captionMessage ?? this.captionMessage,
        replayMessageCustomType:
            replayMessageCustomType ?? this.replayMessageCustomType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (captionMessage != null && captionMessage?.isNotEmpty == true)
          'captionMessage': captionMessage,
        if (country != null && country?.isNotEmpty == true) 'country': country,
        if (parentMessageBody != null && parentMessageBody?.isNotEmpty == true)
          'parentMessageBody': parentMessageBody,
        if (locationAddress != null && locationAddress?.isNotEmpty == true)
          'locationAddress': locationAddress,
        if (locationSubAddress != null &&
            locationSubAddress?.isNotEmpty == true)
          'locationSubAddress': locationSubAddress,
        if (parentMessageInitiator != null)
          'parentMessageInitiator': parentMessageInitiator,
        if (profilePic != null && profilePic?.isNotEmpty == true)
          'profilePic': profilePic,
        if (firstName != null && firstName?.isNotEmpty == true)
          'firstName': firstName,
        if (lastName != null && lastName?.isNotEmpty == true)
          'lastName': lastName,
        if (customType != null && customType?.isNotEmpty == true)
          'customType': customType,
        if (assetList != null && assetList?.isNotEmpty == true)
          'assetList': assetList,
        if (duration != null) 'duration': duration?.inSeconds,
        if (replayMessageCustomType != null)
          'replayMessageCustomType': replayMessageCustomType?.name
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmChatMetaData(country: $country, parentMessageBody: $parentMessageBody, locationAddress: $locationAddress, locationSubAddress: $locationSubAddress, profilePic: $profilePic, lastName: $lastName, firstName: $firstName, parentMessageInitiator: $parentMessageInitiator, customType: $customType, assetList: $assetList, duration: $duration, replayMessageCustomType: $replayMessageCustomType)';
      'IsmChatMetaData(country: $country, parentMessageBody: $parentMessageBody, locationAddress: $locationAddress, locationSubAddress: $locationSubAddress, profilePic: $profilePic, lastName: $lastName, firstName: $firstName, parentMessageInitiator: $parentMessageInitiator, customType: $customType, assetList: $assetList, duration: $duration, captionMessage: $captionMessage)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.parentMessageBody == parentMessageBody &&
        other.locationAddress == locationAddress &&
        other.locationSubAddress == locationSubAddress &&
        other.profilePic == profilePic &&
        other.lastName == lastName &&
        other.firstName == firstName &&
        other.parentMessageInitiator == parentMessageInitiator &&
        mapEquals(other.customType, customType) &&
        listEquals(other.assetList, assetList) &&
        other.duration == duration &&
        other.captionMessage == captionMessage;
        mapEquals(other.customType, customType) &&
        listEquals(other.assetList, assetList) &&
        other.duration == duration &&
        other.replayMessageCustomType == replayMessageCustomType;
  }

  @override
  int get hashCode =>
      country.hashCode ^
      parentMessageBody.hashCode ^
      locationAddress.hashCode ^
      locationSubAddress.hashCode ^
      profilePic.hashCode ^
      lastName.hashCode ^
      firstName.hashCode ^
      parentMessageInitiator.hashCode ^
      customType.hashCode ^
      assetList.hashCode ^
      duration.hashCode ^
      captionMessage.hashCode;
      assetList.hashCode ^
      duration.hashCode ^
      replayMessageCustomType.hashCode;
}
