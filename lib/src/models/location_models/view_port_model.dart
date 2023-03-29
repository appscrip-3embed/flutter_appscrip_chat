// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/src/models/models.dart';

class ViewportModel {
  final LatLongModel northeast;
  final LatLongModel southwest;
  ViewportModel({
    required this.northeast,
    required this.southwest,
  });

  ViewportModel copyWith({
    LatLongModel? northeast,
    LatLongModel? southwest,
  }) =>
      ViewportModel(
        northeast: northeast ?? this.northeast,
        southwest: southwest ?? this.southwest,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'northeast': northeast.toMap(),
        'southwest': southwest.toMap(),
      };

  factory ViewportModel.fromMap(Map<String, dynamic> map) => ViewportModel(
        northeast:
            LatLongModel.fromMap(map['northeast'] as Map<String, dynamic>),
        southwest:
            LatLongModel.fromMap(map['southwest'] as Map<String, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory ViewportModel.fromJson(String source) =>
      ViewportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ViewportModle(northeast: $northeast, southwest: $southwest)';

  @override
  bool operator ==(covariant ViewportModel other) {
    if (identical(this, other)) return true;

    return other.northeast == northeast && other.southwest == southwest;
  }

  @override
  int get hashCode => northeast.hashCode ^ southwest.hashCode;
}
