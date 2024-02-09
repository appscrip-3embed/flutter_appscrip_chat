import 'dart:convert';

class IsmChatContactMetaDatModel {
  IsmChatContactMetaDatModel({
    this.contactName,
    this.contactImageUrl,
    this.contactIdentifier,
  });

  factory IsmChatContactMetaDatModel.fromMap(Map<String, dynamic> map) =>
      IsmChatContactMetaDatModel(
        contactName: map['contactName'] as String? ?? '',
        contactImageUrl: map['contactImageUrl'] as String? ?? '',
        contactIdentifier: map['contactIdentifier'] as String? ?? '',
      );

  factory IsmChatContactMetaDatModel.fromJson(String source) =>
      IsmChatContactMetaDatModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
  final String? contactName;
  final String? contactImageUrl;
  final String? contactIdentifier;

  IsmChatContactMetaDatModel copyWith({
    String? contactName,
    String? contactImageUrl,
    String? contactIdentifier,
  }) =>
      IsmChatContactMetaDatModel(
        contactName: contactName ?? this.contactName,
        contactImageUrl: contactImageUrl ?? this.contactImageUrl,
        contactIdentifier: contactIdentifier ?? this.contactIdentifier,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'contactName': contactName,
        'contactImageUrl': contactImageUrl,
        'contactIdentifier': contactIdentifier,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ContactMetaDatModel(contactName: $contactName, contactImageUrl: $contactImageUrl, contactIdentifier: $contactIdentifier)';

  @override
  bool operator ==(covariant IsmChatContactMetaDatModel other) {
    if (identical(this, other)) return true;

    return other.contactName == contactName &&
        other.contactImageUrl == contactImageUrl &&
        other.contactIdentifier == contactIdentifier;
  }

  @override
  int get hashCode =>
      contactName.hashCode ^
      contactImageUrl.hashCode ^
      contactIdentifier.hashCode;
}
