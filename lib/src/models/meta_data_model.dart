// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

@Entity()
class IsmChatMetaData {
  int id;
  final String? country;
  final String? parentMessageBody;
  final String? locationAddress;
  final String? profilePic;
  final String? lastName;
  final String? firstName;
  final bool? parentMessageInitiator;
  final String? userId;
  final String? isMatchId;
  final bool? isGuestMatch;
  final String? guestMatchInitiatedByUserId;
  final String? guestMatchInitiatedWithUserId;
  final String? genderOfUserWhoStartedGuestChat;
  final String? genderOfUserWhoReceivedTheGuestChat;
  final bool? paidChat;
  IsmChatMetaData({
    this.id = 0,
    this.country,
    this.parentMessageBody,
    this.locationAddress,
    this.profilePic,
    this.parentMessageInitiator,
    this.firstName,
    this.lastName,
    this.isMatchId,
    this.userId,
    this.genderOfUserWhoReceivedTheGuestChat,
    this.genderOfUserWhoStartedGuestChat,
    this.guestMatchInitiatedByUserId,
    this.guestMatchInitiatedWithUserId,
    this.isGuestMatch,
    this.paidChat,
  });

  IsmChatMetaData copyWith({
    String? country,
    String? parentMessageBody,
    String? locationAddress,
    String? profilePic,
    bool? parentMessageInitiator,
    String? lastName,
    String? firstName,
    String? userId,
    String? isMatchId,
    bool? isGuestMatch,
    String? guestMatchInitiatedByUserId,
    String? guestMatchInitiatedWithUserId,
    String? genderOfUserWhoStartedGuestChat,
    String? genderOfUserWhoReceivedTheGuestChat,
    bool? paidChat,
  }) =>
      IsmChatMetaData(
          country: country ?? this.country,
          parentMessageBody: parentMessageBody ?? this.parentMessageBody,
          locationAddress: locationAddress ?? this.locationAddress,
          profilePic: profilePic ?? this.profilePic,
          parentMessageInitiator:
              parentMessageInitiator ?? this.parentMessageInitiator,
          userId: userId ?? this.userId,
          isMatchId: isMatchId ?? this.isMatchId,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          isGuestMatch: isGuestMatch ?? this.isGuestMatch,
          guestMatchInitiatedByUserId:
              guestMatchInitiatedByUserId ?? this.guestMatchInitiatedByUserId,
          genderOfUserWhoReceivedTheGuestChat:
              genderOfUserWhoReceivedTheGuestChat ??
                  this.genderOfUserWhoReceivedTheGuestChat,
          genderOfUserWhoStartedGuestChat: genderOfUserWhoStartedGuestChat ??
              this.genderOfUserWhoStartedGuestChat,
          guestMatchInitiatedWithUserId: guestMatchInitiatedWithUserId ??
              this.guestMatchInitiatedWithUserId,
          paidChat: paidChat ?? this.paidChat);

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (country != null || country?.isNotEmpty == true) 'country': country,
        if (parentMessageBody != null || parentMessageBody?.isNotEmpty == true)
          'parentMessageBody': parentMessageBody,
        if (locationAddress != null || locationAddress?.isNotEmpty == true)
          'locationAddress': locationAddress,
        if (parentMessageInitiator != null)
          'parentMessageInitiator': parentMessageInitiator,
        if (profilePic != null || profilePic?.isNotEmpty == true)
          'profilePic': profilePic,
        if (userId != null || userId?.isNotEmpty == true) 'userId': userId,
        if (isMatchId != null || isMatchId?.isNotEmpty == true)
          'isMatchId': isMatchId,
        if (firstName != null || firstName?.isNotEmpty == true)
          'firstName': firstName,
        if (lastName != null || lastName?.isNotEmpty == true)
          'lastName': lastName,
        if (isGuestMatch != null) 'isGuestMatch': isGuestMatch,
        if (genderOfUserWhoReceivedTheGuestChat != null ||
            genderOfUserWhoReceivedTheGuestChat?.isNotEmpty == true)
          'genderOfUserWhoReceivedTheGuestChat':
              genderOfUserWhoReceivedTheGuestChat,
        if (genderOfUserWhoStartedGuestChat != null ||
            genderOfUserWhoStartedGuestChat?.isNotEmpty == true)
          'genderOfUserWhoStartedGuestChat': genderOfUserWhoStartedGuestChat,
        if (guestMatchInitiatedByUserId != null ||
            guestMatchInitiatedByUserId?.isNotEmpty == true)
          'guestMatchInitiatedByUserId': guestMatchInitiatedByUserId,
        if (guestMatchInitiatedWithUserId != null ||
            guestMatchInitiatedWithUserId?.isNotEmpty == true)
          'guestMatchInitiatedWithUserId': guestMatchInitiatedWithUserId,
        if (paidChat != null) 'paidChat': paidChat
      };

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
      country: map['country'] != null ? map['country'] as String : null,
      parentMessageBody: map['parentMessageBody'] != null
          ? map['parentMessageBody'] as String
          : null,
      locationAddress: map['locationAddress'] != null
          ? map['locationAddress'] as String
          : null,
      profilePic:
          map['profilePic'] != null ? map['profilePic'] as String : null,
      parentMessageInitiator: map['parentMessageInitiator'] != null
          ? map['parentMessageInitiator'] as bool
          : null,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      isMatchId: map['isMatchId'] as String? ?? '',
      isGuestMatch: map['isGuestMatch'] as bool? ?? false,
      genderOfUserWhoReceivedTheGuestChat:
          map['genderOfUserWhoReceivedTheGuestChat'] as String? ?? '',
      genderOfUserWhoStartedGuestChat:
          map['genderOfUserWhoStartedGuestChat'] as String? ?? '',
      guestMatchInitiatedByUserId:
          map['guestMatchInitiatedByUserId'] as String? ?? '',
      guestMatchInitiatedWithUserId:
          map['guestMatchInitiatedWithUserId'] as String? ?? '',
      paidChat: map['paidChat'] as bool? ?? false);

  String toJson() => json.encode(toMap());

  factory IsmChatMetaData.fromJson(String? source) {
    if(source?.isEmpty ==  true || source == null){
      return IsmChatMetaData();
    }
    return IsmChatMetaData.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  @override
  String toString() =>
      'IsmChatMetaData(country: $country, parentMessageBody: $parentMessageBody, locationAddress: $locationAddress, profilePic: $profilePic, parentMessageInitiator: $parentMessageInitiator)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.parentMessageBody == parentMessageBody &&
        other.locationAddress == locationAddress &&
        other.profilePic == profilePic &&
        other.parentMessageInitiator == parentMessageInitiator;
  }

  @override
  int get hashCode =>
      country.hashCode ^
      parentMessageBody.hashCode ^
      locationAddress.hashCode ^
      profilePic.hashCode ^
      parentMessageInitiator.hashCode;
}
