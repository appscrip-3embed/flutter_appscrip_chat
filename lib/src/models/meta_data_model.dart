import 'dart:convert';

class ChatMetaData {
  factory ChatMetaData.fromJson(String source) =>
      ChatMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChatMetaData.fromMap(Map<String, dynamic> map) => ChatMetaData(
        country: map['country'] != null ? map['country'] as String : null,
      );

  ChatMetaData({
    this.country,
  });

  final String? country;

  ChatMetaData copyWith({
    String? country,
  }) =>
      ChatMetaData(
        country: country ?? this.country,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'country': country,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MetaData(country: $country)';

  @override
  bool operator ==(covariant ChatMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country;
  }

  @override
  int get hashCode => country.hashCode;
}
