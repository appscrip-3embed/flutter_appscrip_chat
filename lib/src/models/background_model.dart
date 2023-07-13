// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IsmChatBackgroundModel {
  final bool isImage;
  final String? color;
  final String? imageUrl;
  IsmChatBackgroundModel({
    required this.isImage,
    this.color,
    this.imageUrl,
  });

  IsmChatBackgroundModel copyWith({
    bool? isImage,
    String? color,
    String? imageUrl,
  }) =>
      IsmChatBackgroundModel(
        isImage: isImage ?? this.isImage,
        color: color ?? this.color,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'isImage': isImage,
        'color': color,
        'imageUrl': imageUrl,
      };

  factory IsmChatBackgroundModel.fromMap(Map<String, dynamic> map) =>
      IsmChatBackgroundModel(
        isImage: map['isImage'] as bool,
        color: map['color'] != null ? map['color'] as String : null,
        imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      );

  String toJson() => json.encode(toMap());

  factory IsmChatBackgroundModel.fromJson(String source) =>
      IsmChatBackgroundModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IsmChatBackgroundModel(isImage: $isImage, color: $color, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant IsmChatBackgroundModel other) {
    if (identical(this, other)) return true;

    return other.isImage == isImage &&
        other.color == color &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => isImage.hashCode ^ color.hashCode ^ imageUrl.hashCode;
}
