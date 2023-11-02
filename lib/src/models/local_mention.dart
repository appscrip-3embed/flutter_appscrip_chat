import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LocalMentionAndPhoneNumber {
  const LocalMentionAndPhoneNumber({
    required this.text,
    required this.isMentioned,
    required this.isPhoneNumber,
  });
  final String text;
  final bool isMentioned;
  final bool isPhoneNumber;

  LocalMentionAndPhoneNumber copyWith({
    String? text,
    bool? isMentioned,
    bool? isPhoneNumber,
  }) =>
      LocalMentionAndPhoneNumber(
        text: text ?? this.text,
        isMentioned: isMentioned ?? this.isMentioned,
        isPhoneNumber: isPhoneNumber ?? this.isPhoneNumber,
      );

  @override
  String toString() =>
      'LocalMentionAndPhoneNumber(text: $text, isMentioned: $isMentioned, isPhoneNumber: $isPhoneNumber)';

  Map<String, dynamic> toMap() => <String, dynamic>{
        'text': text,
        'isMentioned': isMentioned,
        'isPhoneNumber': isPhoneNumber,
      };

  factory LocalMentionAndPhoneNumber.fromMap(Map<String, dynamic> map) =>
      LocalMentionAndPhoneNumber(
        text: map['text'] as String,
        isMentioned: map['isMentioned'] as bool,
        isPhoneNumber: map['isPhoneNumber'] as bool,
      );

  String toJson() => json.encode(toMap());

  factory LocalMentionAndPhoneNumber.fromJson(String source) =>
      LocalMentionAndPhoneNumber.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
