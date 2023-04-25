// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatGeometry {
  final IsmChatLatLongModel? location;
  final IsmChatViewportModel? viewport;
  IsmChatGeometry({
    this.location,
    this.viewport,
  });

  IsmChatGeometry copyWith({
    IsmChatLatLongModel? location,
    IsmChatViewportModel? viewport,
  }) =>
      IsmChatGeometry(
        location: location ?? this.location,
        viewport: viewport ?? this.viewport,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'location': location?.toMap(),
        'viewport': viewport?.toMap(),
      };

  factory IsmChatGeometry.fromMap(Map<String, dynamic> map) => IsmChatGeometry(
        location: map['location'] != null
            ? IsmChatLatLongModel.fromMap(
                map['location'] as Map<String, dynamic>)
            : null,
        viewport: map['viewport'] != null
            ? IsmChatViewportModel.fromMap(
                map['viewport'] as Map<String, dynamic>)
            : null,
      );

  String toJson() => json.encode(toMap());

  factory IsmChatGeometry.fromJson(String source) =>
      IsmChatGeometry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Geometry(location: $location, viewport: $viewport)';

  @override
  bool operator ==(covariant IsmChatGeometry other) {
    if (identical(this, other)) return true;

    return other.location == location && other.viewport == viewport;
  }

  @override
  int get hashCode => location.hashCode ^ viewport.hashCode;
}
