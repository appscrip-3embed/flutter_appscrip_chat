// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LatLongModel {
  final double lat;
  final double lng;
  LatLongModel({
    required this.lat,
    required this.lng,
  });

  LatLongModel copyWith({
    double? lat,
    double? lng,
  }) =>
      LatLongModel(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'lat': lat,
        'lng': lng,
      };

  factory LatLongModel.fromMap(Map<String, dynamic> map) => LatLongModel(
        lat: map['lat'] as double,
        lng: map['lng'] as double,
      );
  LatLng get latlng => LatLng(lat, lng);

  String toJson() => json.encode(toMap());

  factory LatLongModel.fromJson(String source) =>
      LatLongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LatLongModel(lat: $lat, lng: $lng)';

  @override
  bool operator ==(covariant LatLongModel other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
