import 'dart:convert';

class IsmChatMetaData {
  factory IsmChatMetaData.fromJson(String source) =>
      IsmChatMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

  factory IsmChatMetaData.fromMap(Map<String, dynamic> map) => IsmChatMetaData(
        country: map['country'] != null ? map['country'] as String : null,
      );

  IsmChatMetaData({
    this.country,
  });

  final String? country;

  IsmChatMetaData copyWith({
    String? country,
  }) =>
      IsmChatMetaData(
        country: country ?? this.country,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'country': country,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MetaData(country: $country)';

  @override
  bool operator ==(covariant IsmChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country;
  }

  @override
  int get hashCode => country.hashCode;
}
