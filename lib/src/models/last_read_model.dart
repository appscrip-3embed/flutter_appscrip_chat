import 'dart:convert';

class LastReadAt {
  factory LastReadAt.fromJson(String source) =>
      LastReadAt.fromMap(json.decode(source) as Map<String, dynamic>);

  factory LastReadAt.fromMap(Map<String, dynamic> map) => LastReadAt(
        userId: map['userId'] as String,
        readAt: map['readAt'] as int,
      );

  const LastReadAt({
    required this.userId,
    required this.readAt,
  });
  final String userId;
  final int readAt;

  LastReadAt copyWith({
    String? userId,
    int? readAt,
  }) =>
      LastReadAt(
        userId: userId ?? this.userId,
        readAt: readAt ?? this.readAt,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'readAt': readAt,
      };

  static List<LastReadAt> fromNetworkMap(Map<String, dynamic> map) {
    var data = <LastReadAt>[];
    for (MapEntry map in map.entries) {
      data.add(
        LastReadAt(
          userId: map.key as String,
          readAt: map.value as int,
        ),
      );
    }
    return data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'LastReadAt(userId: $userId, readAt: $readAt)';

  @override
  bool operator ==(covariant LastReadAt other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.readAt == readAt;
  }

  @override
  int get hashCode => userId.hashCode ^ readAt.hashCode;
}
