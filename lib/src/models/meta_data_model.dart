// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class IsmChatMetaData {
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
    this.paidChat
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
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (country != null || country?.isNotEmpty == true) 'country': country,
        if (parentMessageBody != null || parentMessageBody?.isNotEmpty == true)
          'parentMessageBody': parentMessageBody,
        if (locationAddress != null || locationAddress?.isNotEmpty == true)
          'locationAddress': locationAddress,
        if (parentMessageInitiator != null)
          'parentMessageInitiator': parentMessageInitiator,
        if (profilePic != null || profilePic?.isNotEmpty == true)
          'profilePic': profilePic
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
      );

  String toJson() => json.encode(toMap());

  factory IsmChatMetaData.fromJson(String source) =>
      IsmChatMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

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
