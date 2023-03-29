// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Term {
  final int? offset;
  final String? value;
  Term({
    this.offset,
    this.value,
  });

  Term copyWith({
    int? offset,
    String? value,
  }) =>
      Term(
        offset: offset ?? this.offset,
        value: value ?? this.value,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'offset': offset,
        'value': value,
      };

  factory Term.fromMap(Map<String, dynamic> map) => Term(
        offset: map['offset'] != null ? map['offset'] as int : null,
        value: map['value'] != null ? map['value'] as String : null,
      );

  String toJson() => json.encode(toMap());

  factory Term.fromJson(String source) =>
      Term.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Term(offset: $offset, value: $value)';

  @override
  bool operator ==(covariant Term other) {
    if (identical(this, other)) return true;

    return other.offset == offset && other.value == value;
  }

  @override
  int get hashCode => offset.hashCode ^ value.hashCode;
}
