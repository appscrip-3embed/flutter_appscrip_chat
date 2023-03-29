// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Prediction {
  final String? description;
  final List<MatchedSubstring>? matchedSubstrings;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final List<Term>? terms;
  final List<String>? types;
  final Geometry? geometry;
  final double? distance;
  final String? businessStatus;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final dynamic rating;
  final String? scope;
  final int? userRatingsTotal;
  final String? vicinity;
  Prediction({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
    this.geometry,
    this.distance,
    this.businessStatus,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    required this.rating,
    this.scope,
    this.userRatingsTotal,
    this.vicinity,
  });

  Prediction copyWith({
    String? description,
    List<MatchedSubstring>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    List<Term>? terms,
    List<String>? types,
    Geometry? geometry,
    double? distance,
    String? businessStatus,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    dynamic? rating,
    String? scope,
    int? userRatingsTotal,
    String? vicinity,
  }) =>
      Prediction(
        description: description ?? this.description,
        matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
        placeId: placeId ?? this.placeId,
        reference: reference ?? this.reference,
        structuredFormatting: structuredFormatting ?? this.structuredFormatting,
        terms: terms ?? this.terms,
        types: types ?? this.types,
        geometry: geometry ?? this.geometry,
        distance: distance ?? this.distance,
        businessStatus: businessStatus ?? this.businessStatus,
        icon: icon ?? this.icon,
        iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
        iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
        name: name ?? this.name,
        rating: rating ?? this.rating,
        scope: scope ?? this.scope,
        userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
        vicinity: vicinity ?? this.vicinity,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'description': description,
        'matchedSubstrings': matchedSubstrings!.map((x) => x.toMap()).toList(),
        'placeId': placeId,
        'reference': reference,
        'structuredFormatting': structuredFormatting?.toMap(),
        'terms': terms!.map((x) => x.toMap()).toList(),
        'types': types,
        'geometry': geometry?.toMap(),
        'distance': distance,
        'businessStatus': businessStatus,
        'icon': icon,
        'iconBackgroundColor': iconBackgroundColor,
        'iconMaskBaseUri': iconMaskBaseUri,
        'name': name,
        'rating': rating,
        'scope': scope,
        'userRatingsTotal': userRatingsTotal,
        'vicinity': vicinity,
      };

  factory Prediction.fromMap(Map<String, dynamic> map, {LatLng? latlng}) {
    var predictaion = Prediction(
      description:
          map['description'] != null ? map['description'] as String : null,
      matchedSubstrings: map['matchedSubstrings'] != null
          ? List<MatchedSubstring>.from(
              (map['matchedSubstrings'] as List<int>).map<MatchedSubstring?>(
                (x) => MatchedSubstring.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      placeId: map['placeId'] != null ? map['placeId'] as String : null,
      reference: map['reference'] != null ? map['reference'] as String : null,
      structuredFormatting: map['structuredFormatting'] != null
          ? StructuredFormatting.fromMap(
              map['structuredFormatting'] as Map<String, dynamic>)
          : null,
      terms: map['terms'] != null
          ? List<Term>.from(
              (map['terms'] as List<int>).map<Term?>(
                (x) => Term.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      types:
          map['types'] != null ? List<String>.from(map['types'] as List) : null,
      geometry: map['geometry'] != null
          ? Geometry.fromMap(map['geometry'] as Map<String, dynamic>)
          : null,
      distance: map['distance'] != null ? map['distance'] as double : null,
      businessStatus: map['businessStatus'] != null
          ? map['businessStatus'] as String
          : null,
      icon: map['icon'] != null ? map['icon'] as String : null,
      iconBackgroundColor: map['iconBackgroundColor'] != null
          ? map['iconBackgroundColor'] as String
          : null,
      iconMaskBaseUri: map['iconMaskBaseUri'] != null
          ? map['iconMaskBaseUri'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      rating: map['rating'] as dynamic,
      scope: map['scope'] != null ? map['scope'] as String : null,
      userRatingsTotal: map['userRatingsTotal'] != null
          ? map['userRatingsTotal'] as int
          : null,
      vicinity: map['vicinity'] != null ? map['vicinity'] as String : null,
    );
    if (latlng == null) {
      return predictaion;
    }
    return predictaion.copyWith(
        distance: latlng.getDistance(predictaion.geometry!.location!.latlng));
  }

  String toJson() => json.encode(toMap());

  factory Prediction.fromJson(String source) =>
      Prediction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Prediction(description: $description, matchedSubstrings: $matchedSubstrings, placeId: $placeId, reference: $reference, structuredFormatting: $structuredFormatting, terms: $terms, types: $types, geometry: $geometry, distance: $distance, businessStatus: $businessStatus, icon: $icon, iconBackgroundColor: $iconBackgroundColor, iconMaskBaseUri: $iconMaskBaseUri, name: $name, rating: $rating, scope: $scope, userRatingsTotal: $userRatingsTotal, vicinity: $vicinity)';

  @override
  bool operator ==(covariant Prediction other) {
    if (identical(this, other)) return true;

    return other.description == description &&
        listEquals(other.matchedSubstrings, matchedSubstrings) &&
        other.placeId == placeId &&
        other.reference == reference &&
        other.structuredFormatting == structuredFormatting &&
        listEquals(other.terms, terms) &&
        listEquals(other.types, types) &&
        other.geometry == geometry &&
        other.distance == distance &&
        other.businessStatus == businessStatus &&
        other.icon == icon &&
        other.iconBackgroundColor == iconBackgroundColor &&
        other.iconMaskBaseUri == iconMaskBaseUri &&
        other.name == name &&
        other.rating == rating &&
        other.scope == scope &&
        other.userRatingsTotal == userRatingsTotal &&
        other.vicinity == vicinity;
  }

  @override
  int get hashCode =>
      description.hashCode ^
      matchedSubstrings.hashCode ^
      placeId.hashCode ^
      reference.hashCode ^
      structuredFormatting.hashCode ^
      terms.hashCode ^
      types.hashCode ^
      geometry.hashCode ^
      distance.hashCode ^
      businessStatus.hashCode ^
      icon.hashCode ^
      iconBackgroundColor.hashCode ^
      iconMaskBaseUri.hashCode ^
      name.hashCode ^
      rating.hashCode ^
      scope.hashCode ^
      userRatingsTotal.hashCode ^
      vicinity.hashCode;
}
