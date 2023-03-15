import 'dart:convert';

class ConversationConfig {
  factory ConversationConfig.fromJson(String source) =>
      ConversationConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ConversationConfig.fromMap(Map<String, dynamic> map) =>
      ConversationConfig(
        typingEvents: map['typingEvents'] as bool,
        readEvents: map['readEvents'] as bool,
        pushNotifications: map['pushNotifications'] as bool,
      );

  const ConversationConfig({
    required this.typingEvents,
    required this.readEvents,
    required this.pushNotifications,
  });
  final bool typingEvents;
  final bool readEvents;
  final bool pushNotifications;

  ConversationConfig copyWith({
    bool? typingEvents,
    bool? readEvents,
    bool? pushNotifications,
  }) =>
      ConversationConfig(
        typingEvents: typingEvents ?? this.typingEvents,
        readEvents: readEvents ?? this.readEvents,
        pushNotifications: pushNotifications ?? this.pushNotifications,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'typingEvents': typingEvents,
        'readEvents': readEvents,
        'pushNotifications': pushNotifications,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ConversationConfig(typingEvents: $typingEvents, readEvents: $readEvents, pushNotifications: $pushNotifications)';

  @override
  bool operator ==(covariant ConversationConfig other) {
    if (identical(this, other)) return true;

    return other.typingEvents == typingEvents &&
        other.readEvents == readEvents &&
        other.pushNotifications == pushNotifications;
  }

  @override
  int get hashCode =>
      typingEvents.hashCode ^ readEvents.hashCode ^ pushNotifications.hashCode;
}
