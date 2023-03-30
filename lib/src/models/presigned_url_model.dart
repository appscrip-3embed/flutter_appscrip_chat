// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PresignedUrlModel {
  num? ttl;
  String? thumbnailUrl;
  String? thumbnailPresignedUrl;
  String? mediaUrl;
  String? mediaPresignedUrl;
  String? mediaId;
  PresignedUrlModel({
    this.ttl,
    this.thumbnailUrl,
    this.thumbnailPresignedUrl,
    this.mediaUrl,
    this.mediaPresignedUrl,
    this.mediaId,
  });

  PresignedUrlModel copyWith({
    num? ttl,
    String? thumbnailUrl,
    String? thumbnailPresignedUrl,
    String? mediaUrl,
    String? mediaPresignedUrl,
    String? mediaId,
  }) =>
      PresignedUrlModel(
        ttl: ttl ?? this.ttl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        thumbnailPresignedUrl:
            thumbnailPresignedUrl ?? this.thumbnailPresignedUrl,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaPresignedUrl: mediaPresignedUrl ?? this.mediaPresignedUrl,
        mediaId: mediaId ?? this.mediaId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'ttl': ttl,
        'thumbnailUrl': thumbnailUrl,
        'thumbnailPresignedUrl': thumbnailPresignedUrl,
        'mediaUrl': mediaUrl,
        'mediaPresignedUrl': mediaPresignedUrl,
        'mediaId': mediaId,
      };

  factory PresignedUrlModel.fromMap(Map<String, dynamic> map) =>
      PresignedUrlModel(
        ttl: map['ttl'] != null ? map['ttl'] as num : null,
        thumbnailUrl:
            map['thumbnailUrl'] != null ? map['thumbnailUrl'] as String : null,
        thumbnailPresignedUrl: map['thumbnailPresignedUrl'] != null
            ? map['thumbnailPresignedUrl'] as String
            : null,
        mediaUrl: map['mediaUrl'] != null ? map['mediaUrl'] as String : null,
        mediaPresignedUrl: map['mediaPresignedUrl'] != null
            ? map['mediaPresignedUrl'] as String
            : null,
        mediaId: map['mediaId'] != null ? map['mediaId'] as String : null,
      );

  String toJson() => json.encode(toMap());

  factory PresignedUrlModel.fromJson(String source) =>
      PresignedUrlModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PresignedUrlModel(ttl: $ttl, thumbnailUrl: $thumbnailUrl, thumbnailPresignedUrl: $thumbnailPresignedUrl, mediaUrl: $mediaUrl, mediaPresignedUrl: $mediaPresignedUrl, mediaId: $mediaId)';

  @override
  bool operator ==(covariant PresignedUrlModel other) {
    if (identical(this, other)) return true;

    return other.ttl == ttl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.thumbnailPresignedUrl == thumbnailPresignedUrl &&
        other.mediaUrl == mediaUrl &&
        other.mediaPresignedUrl == mediaPresignedUrl &&
        other.mediaId == mediaId;
  }

  @override
  int get hashCode =>
      ttl.hashCode ^
      thumbnailUrl.hashCode ^
      thumbnailPresignedUrl.hashCode ^
      mediaUrl.hashCode ^
      mediaPresignedUrl.hashCode ^
      mediaId.hashCode;
}
