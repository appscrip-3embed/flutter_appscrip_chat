// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IsmChatMetaData {
  final String? country;
  final String? parentMessageBody;
  final String? locationAddress;
  final bool? parentMessageInitiator;
  IsmChatMetaData({
    this.country,
    this.parentMessageBody,
    this.locationAddress,
    this.parentMessageInitiator,
  });

  IsmChatMetaData copyWith({
    String? country,
    String? parentMessageBody,
    String? locationAddress,
    bool? parentMessageInitiator,
  }) =>
      IsmChatMetaData(
        country: country ?? this.country,
        parentMessageBody: parentMessageBody ?? this.parentMessageBody,
        locationAddress: locationAddress ?? this.locationAddress,
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
      };

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
        country: map['country'] != null ? map['country'] as String : null,
        parentMessageBody: map['parentMessageBody'] != null
            ? map['parentMessageBody'] as String
            : null,
        locationAddress: map['locationAddress'] != null
            ? map['locationAddress'] as String
            : null,
        parentMessageInitiator: map['parentMessageInitiator'] != null
            ? map['parentMessageInitiator'] as bool
            : null,
      );

  String toJson() => json.encode(toMap());

  factory IsmChatMetaData.fromJson(String source) =>
      IsmChatMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IsmChatMetaData(country: $country, parentMessageBody: $parentMessageBody, locationAddress: $locationAddress, parentMessageInitiator: $parentMessageInitiator)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.parentMessageBody == parentMessageBody &&
        other.locationAddress == locationAddress &&
        other.parentMessageInitiator == parentMessageInitiator;
  }

  @override
  int get hashCode =>
      country.hashCode ^
      parentMessageBody.hashCode ^
      locationAddress.hashCode ^
      parentMessageInitiator.hashCode;
}
