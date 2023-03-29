// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MatchedSubstring {
  final int? length;
  final int? offset;
  MatchedSubstring({
    this.length,
    this.offset,
  });

  MatchedSubstring copyWith({
    int? length,
    int? offset,
  }) =>
      MatchedSubstring(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'length': length,
        'offset': offset,
      };

  factory MatchedSubstring.fromMap(Map<String, dynamic> map) =>
      MatchedSubstring(
        length: map['length'] != null ? map['length'] as int : null,
        offset: map['offset'] != null ? map['offset'] as int : null,
      );

  String toJson() => json.encode(toMap());

  factory MatchedSubstring.fromJson(String source) =>
      MatchedSubstring.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MatchedSubstring(length: $length, offset: $offset)';

  @override
  bool operator ==(covariant MatchedSubstring other) {
    if (identical(this, other)) return true;

    return other.length == length && other.offset == offset;
  }

  @override
  int get hashCode => length.hashCode ^ offset.hashCode;
}
