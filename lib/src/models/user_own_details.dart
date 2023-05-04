import 'dart:convert';

class IsmChatUserOwnDetails {
  factory IsmChatUserOwnDetails.fromJson(String source) =>
      IsmChatUserOwnDetails.fromMap(
          json.decode(source) as Map<String, dynamic>);

  factory IsmChatUserOwnDetails.fromMap(Map<String, dynamic> map) =>
      IsmChatUserOwnDetails(
        memberId: map['memberId'] as String? ?? '',
        isAdmin: map['isAdmin'] as bool? ?? false,
      );
  IsmChatUserOwnDetails({
    required this.memberId,
    required this.isAdmin,
  });
  final String memberId;
  final bool isAdmin;

  IsmChatUserOwnDetails copyWith({
    String? memberId,
    bool? isAdmin,
  }) =>
      IsmChatUserOwnDetails(
        memberId: memberId ?? this.memberId,
        isAdmin: isAdmin ?? this.isAdmin,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'memberId': memberId,
        'isAdmin': isAdmin,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmChatUserOwnDetails(memberId: $memberId, isAdmin: $isAdmin)';

  @override
  bool operator ==(covariant IsmChatUserOwnDetails other) {
    if (identical(this, other)) return true;

    return other.memberId == memberId && other.isAdmin == isAdmin;
  }

  @override
  int get hashCode => memberId.hashCode ^ isAdmin.hashCode;
}
