// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IsmChatEvents {
  bool? typingEvents;
  bool? readEvents;
  bool? pushNotifications;
  IsmChatEvents({
    this.typingEvents,
    this.readEvents,
    this.pushNotifications,
  });

  IsmChatEvents copyWith({
    bool? typingEvents,
    bool? readEvents,
    bool? pushNotifications,
  }) =>
      IsmChatEvents(
        typingEvents: typingEvents ?? this.typingEvents,
        readEvents: readEvents ?? this.readEvents,
        pushNotifications: pushNotifications ?? this.pushNotifications,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (typingEvents != null) 'typingEvents': typingEvents,
        if (readEvents != null) 'readEvents': readEvents,
        if (pushNotifications != null) 'pushNotifications': pushNotifications,
      };

  factory IsmChatEvents.fromMap(Map<String, dynamic> map) => IsmChatEvents(
        typingEvents:
            map['typingEvents'] != null ? map['typingEvents'] as bool : null,
        readEvents:
            map['readEvents'] != null ? map['readEvents'] as bool : null,
        pushNotifications: map['pushNotifications'] != null
            ? map['pushNotifications'] as bool
            : null,
      );

  String toJson() => json.encode(toMap());

  factory IsmChatEvents.fromJson(String source) =>
      IsmChatEvents.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Events(typingEvents: $typingEvents, readEvents: $readEvents, pushNotifications: $pushNotifications)';

  @override
  bool operator ==(covariant IsmChatEvents other) {
    if (identical(this, other)) return true;

    return other.typingEvents == typingEvents &&
        other.readEvents == readEvents &&
        other.pushNotifications == pushNotifications;
  }

  @override
  int get hashCode =>
      typingEvents.hashCode ^ readEvents.hashCode ^ pushNotifications.hashCode;
}
