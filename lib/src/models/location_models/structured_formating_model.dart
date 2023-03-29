// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';

class StructuredFormatting {
  String? mainText;
  List<MatchedSubstring>? matchedString;
  String? secondaryText;
  StructuredFormatting({
    this.mainText,
    this.matchedString,
    this.secondaryText,
  });

  StructuredFormatting copyWith({
    String? mainText,
    List<MatchedSubstring>? matchedString,
    String? secondaryText,
  }) =>
      StructuredFormatting(
        mainText: mainText ?? this.mainText,
        matchedString: matchedString ?? this.matchedString,
        secondaryText: secondaryText ?? this.secondaryText,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'mainText': mainText,
        'matchedString': matchedString!.map((x) => x.toMap()).toList(),
        'secondaryText': secondaryText,
      };

  factory StructuredFormatting.fromMap(Map<String, dynamic> map) =>
      StructuredFormatting(
        mainText: map['mainText'] != null ? map['mainText'] as String : null,
        matchedString: map['matchedString'] != null
            ? List<MatchedSubstring>.from(
                (map['matchedString'] as List<int>).map<MatchedSubstring?>(
                  (x) => MatchedSubstring.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        secondaryText: map['secondaryText'] != null
            ? map['secondaryText'] as String
            : null,
      );

  String toJson() => json.encode(toMap());

  factory StructuredFormatting.fromJson(String source) =>
      StructuredFormatting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StructuredFormatting(mainText: $mainText, matchedString: $matchedString, secondaryText: $secondaryText)';

  @override
  bool operator ==(covariant StructuredFormatting other) {
    if (identical(this, other)) return true;

    return other.mainText == mainText &&
        listEquals(other.matchedString, matchedString) &&
        other.secondaryText == secondaryText;
  }

  @override
  int get hashCode =>
      mainText.hashCode ^ matchedString.hashCode ^ secondaryText.hashCode;
}
