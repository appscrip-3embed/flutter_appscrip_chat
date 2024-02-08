import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';

class IsmChatMetaData {
  IsmChatMetaData({
    this.parentMessageBody,
    this.locationAddress,
    this.locationSubAddress,
    this.profilePic,
    this.lastName,
    this.firstName,
    this.contactName,
    this.contactImageUrl,
    this.contactIdentifier,
    this.parentMessageInitiator,
    this.customType,
    this.assetList,
    this.duration,
    this.captionMessage,
    this.replayMessageCustomType,
  });

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
        captionMessage: map['captionMessage'] != null
            ? IsmChatUtility.decodeString(map['captionMessage'] as String)
            : '',
        replayMessageCustomType: map['replayMessageCustomType'] != null
            ? IsmChatCustomMessageType.fromString(
                map['replayMessageCustomType'])
            : null,
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
        contactName: map['contactName'] as String? ?? '',
        contactImageUrl: map['contactImageUrl'] as String? ?? '',
        contactIdentifier: map['contactIdentifier'] as String? ?? '',
      );

  factory IsmChatMetaData.fromJson(String? source) {
    if (source?.isEmpty == true || source == null) {
      return IsmChatMetaData();
    }
    return IsmChatMetaData.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  final String? parentMessageBody;
  final String? locationAddress;
  final String? locationSubAddress;
  final String? profilePic;
  final String? lastName;
  final String? firstName;
  final String? contactName;
  final String? contactImageUrl;
  final String? contactIdentifier;
  final bool? parentMessageInitiator;
  final Map<String, dynamic>? customType;
  final List<Map<String, IsmChatBackgroundModel>>? assetList;
  final Duration? duration;
  final String? captionMessage;
  final IsmChatCustomMessageType? replayMessageCustomType;

  IsmChatMetaData copyWith({
    String? parentMessageBody,
    String? locationAddress,
    String? locationSubAddress,
    String? profilePic,
    String? lastName,
    String? firstName,
    String? contactName,
    String? contactImageUrl,
    String? contactIdentifier,
    bool? parentMessageInitiator,
    Map<String, dynamic>? customType,
    List<Map<String, IsmChatBackgroundModel>>? assetList,
    Duration? duration,
    String? captionMessage,
    IsmChatCustomMessageType? replayMessageCustomType,
  }) =>
      IsmChatMetaData(
        parentMessageBody: parentMessageBody ?? this.parentMessageBody,
        locationAddress: locationAddress ?? this.locationAddress,
        locationSubAddress: locationSubAddress ?? this.locationSubAddress,
        profilePic: profilePic ?? this.profilePic,
        lastName: lastName ?? this.lastName,
        firstName: firstName ?? this.firstName,
        contactName: contactName ?? this.contactName,
        contactImageUrl: contactImageUrl ?? this.contactImageUrl,
        contactIdentifier: contactIdentifier ?? this.contactIdentifier,
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
        'parentMessageBody': parentMessageBody,
        'locationAddress': locationAddress,
        'locationSubAddress': locationSubAddress,
        'profilePic': profilePic,
        'lastName': lastName,
        'firstName': firstName,
        'contactName': contactName,
        'contactImageUrl': contactImageUrl,
        'contactIdentifier': contactIdentifier,
        'parentMessageInitiator': parentMessageInitiator,
        'customType': customType,
        'assetList': assetList,
        'duration': duration?.inSeconds,
        'captionMessage': captionMessage,
        'replayMessageCustomType': replayMessageCustomType?.value,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmChatMetaData(parentMessageBody: $parentMessageBody, locationAddress: $locationAddress, locationSubAddress: $locationSubAddress, profilePic: $profilePic, lastName: $lastName, firstName: $firstName, contactName: $contactName, contactImageUrl: $contactImageUrl, contactIdentifier: $contactIdentifier, parentMessageInitiator: $parentMessageInitiator, customType: $customType, assetList: $assetList, duration: $duration, captionMessage: $captionMessage, replayMessageCustomType: $replayMessageCustomType)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.parentMessageBody == parentMessageBody &&
        other.locationAddress == locationAddress &&
        other.locationSubAddress == locationSubAddress &&
        other.profilePic == profilePic &&
        other.lastName == lastName &&
        other.firstName == firstName &&
        other.contactName == contactName &&
        other.contactImageUrl == contactImageUrl &&
        other.contactIdentifier == contactIdentifier &&
        other.parentMessageInitiator == parentMessageInitiator &&
        mapEquals(other.customType, customType) &&
        listEquals(other.assetList, assetList) &&
        other.duration == duration &&
        other.captionMessage == captionMessage &&
        other.replayMessageCustomType == replayMessageCustomType;
  }

  @override
  int get hashCode =>
      parentMessageBody.hashCode ^
      locationAddress.hashCode ^
      locationSubAddress.hashCode ^
      profilePic.hashCode ^
      lastName.hashCode ^
      firstName.hashCode ^
      contactName.hashCode ^
      contactImageUrl.hashCode ^
      contactIdentifier.hashCode ^
      parentMessageInitiator.hashCode ^
      customType.hashCode ^
      assetList.hashCode ^
      duration.hashCode ^
      captionMessage.hashCode ^
      replayMessageCustomType.hashCode;
}
