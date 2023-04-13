// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IsmChatMetaData {
  final String? country;
  final String? parentMessageBody;
  final String? locationAdress;
  IsmChatMetaData({
    this.country,
    this.parentMessageBody,
    this.locationAdress,
  });

  IsmChatMetaData copyWith({
    String? country,
    String? parentMessageBody,
    String? locationAdress,
  }) =>
      IsmChatMetaData(
        country: country ?? this.country,
        parentMessageBody: parentMessageBody ?? this.parentMessageBody,
        locationAdress: locationAdress ?? this.locationAdress,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (country?.isNotEmpty == true) 'country': country,
        if (parentMessageBody?.isNotEmpty == true)
          'parentMessageBody': parentMessageBody,
        if (locationAdress?.isNotEmpty == true)
          'locationAdress': locationAdress,
      };

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
        country: map['country'] != null ? map['country'] as String : null,
        parentMessageBody: map['parentMessageBody'] != null
            ? map['parentMessageBody'] as String
            : null,
        locationAdress: map['locationAdress'] != null
            ? map['locationAdress'] as String
            : null,
      );

  String toJson() => json.encode(toMap());

  factory IsmChatMetaData.fromJson(String source) =>
      IsmChatMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IsmChatMetaData(country: $country, parentMessageBody: $parentMessageBody, locationAdress: $locationAdress)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.parentMessageBody == parentMessageBody &&
        other.locationAdress == locationAdress;
  }

  @override
  int get hashCode =>
      country.hashCode ^ parentMessageBody.hashCode ^ locationAdress.hashCode;
}
