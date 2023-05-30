// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Reaction {
  final String reactionType;
  final String messageId;
  final String conversationId;
  Reaction({
    required this.reactionType,
    required this.messageId,
    required this.conversationId,
  });

  Reaction copyWith({
    String? reactionType,
    String? messageId,
    String? conversationId,
  }) => Reaction(
      reactionType: reactionType ?? this.reactionType,
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
    );

  Map<String, dynamic> toMap() => <String, dynamic>{
      'reactionType': reactionType,
      'messageId': messageId,
      'conversationId': conversationId,
    };

  factory Reaction.fromMap(Map<String, dynamic> map) => Reaction(
      reactionType: map['reactionType'] as String,
      messageId: map['messageId'] as String,
      conversationId: map['conversationId'] as String,
    );

  String toJson() => json.encode(toMap());

  factory Reaction.fromJson(String source) => Reaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Reaction(reactionType: $reactionType, messageId: $messageId, conversationId: $conversationId)';

  @override
  bool operator ==(covariant Reaction other) {
    if (identical(this, other)) return true;
  
    return 
      other.reactionType == reactionType &&
      other.messageId == messageId &&
      other.conversationId == conversationId;
  }

  @override
  int get hashCode => reactionType.hashCode ^ messageId.hashCode ^ conversationId.hashCode;
}
