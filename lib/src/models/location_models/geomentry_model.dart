// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';



class Geometry {
 
  final LatLongModel? location;
  final ViewportModel? viewport;
  Geometry({
    this.location,
    this.viewport,
  });
  

  Geometry copyWith({
    LatLongModel? location,
    ViewportModel? viewport,
  }) => Geometry(
      location: location ?? this.location,
      viewport: viewport ?? this.viewport,
    );

  Map<String, dynamic> toMap() => <String, dynamic>{
      'location': location?.toMap(),
      'viewport': viewport?.toMap(),
    };

  factory Geometry.fromMap(Map<String, dynamic> map) => Geometry(
      location: map['location'] != null ? LatLongModel.fromMap(map['location'] as Map<String,dynamic>) : null,
      viewport: map['viewport'] != null ? ViewportModel.fromMap(map['viewport'] as Map<String,dynamic>) : null,
    );

  String toJson() => json.encode(toMap());

  factory Geometry.fromJson(String source) => Geometry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Geometry(location: $location, viewport: $viewport)';

  @override
  bool operator ==(covariant Geometry other) {
    if (identical(this, other)) return true;
  
    return 
      other.location == location &&
      other.viewport == viewport;
  }

  @override
  int get hashCode => location.hashCode ^ viewport.hashCode;
}
