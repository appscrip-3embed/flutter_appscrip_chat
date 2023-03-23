import 'dart:convert';

import 'package:appscrip_chat_component/src/utilities/utilities.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AttachmentModel {
  factory AttachmentModel.fromJson(String source) =>
      AttachmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory AttachmentModel.fromMap(Map<String, dynamic> map) => AttachmentModel(
        thumbnailUrl: map['thumbnailUrl'] != null &&
                (map['thumbnailUrl'] as String).isNotEmpty
            ? ChatUtility.decodePayload(map['thumbnailUrl'] as String)
            : '',
        size: map['size'] as double,
        name: map['name'] as String,
        mimeType: map['mimeType'] as String,
        mediaUrl:
            map['mediaUrl'] != null && (map['mediaUrl'] as String).isNotEmpty
                ? ChatUtility.decodePayload(map['mediaUrl'] as String)
                : '',
        mediaId: map['mediaId'] as String,
        extension: map['extension'] as String,
        attachmentType: AttachmentType.fromMap(map['attachmentType'] as int),
      );

  AttachmentModel({
    this.id = 0,
    required this.thumbnailUrl,
    required this.size,
    required this.name,
    required this.mimeType,
    required this.mediaUrl,
    required this.mediaId,
    required this.extension,
    this.attachmentType,
  });
  
  int id;
  final String thumbnailUrl;
  final double size;
  final String name;
  final String mimeType;
  final String mediaUrl;
  final String mediaId;
  final String extension;
  @Transient()
  AttachmentType? attachmentType;


   int? get attachmentIndex => attachmentType?.index;

  set attachmentIndex(int? value) {
    if (value == null) {
      attachmentType = null;
    }
    if (value! < 0 || value >= AttachmentType.values.length) {
      attachmentType = AttachmentType.file;
    }
    attachmentType = AttachmentType.values[value];
  }

  AttachmentModel copyWith({
    String? thumbnailUrl,
    double? size,
    String? name,
    String? mimeType,
    String? mediaUrl,
    String? mediaId,
    String? extension,
    AttachmentType? attachmentType,
  }) =>
      AttachmentModel(
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        size: size ?? this.size,
        name: name ?? this.name,
        mimeType: mimeType ?? this.mimeType,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        mediaId: mediaId ?? this.mediaId,
        extension: extension ?? this.extension,
        attachmentType: attachmentType ?? this.attachmentType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'thumbnailUrl': thumbnailUrl,
        'size': size,
        'name': name,
        'mimeType': mimeType,
        'mediaUrl': mediaUrl,
        'mediaId': mediaId,
        'extension': extension,
        'attachmentType': attachmentType?.value,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'SendAttachmentModel(thumbnailUrl: $thumbnailUrl, size: $size, name: $name, mimeType: $mimeType, mediaUrl: $mediaUrl, mediaId: $mediaId, extension: $extension, attachmentType: $attachmentType)';

  @override
  bool operator ==(covariant AttachmentModel other) {
    if (identical(this, other)) return true;

    return other.thumbnailUrl == thumbnailUrl &&
        other.size == size &&
        other.name == name &&
        other.mimeType == mimeType &&
        other.mediaUrl == mediaUrl &&
        other.mediaId == mediaId &&
        other.extension == extension &&
        other.attachmentType == attachmentType;
  }

  @override
  int get hashCode =>
      thumbnailUrl.hashCode ^
      size.hashCode ^
      name.hashCode ^
      mimeType.hashCode ^
      mediaUrl.hashCode ^
      mediaId.hashCode ^
      extension.hashCode ^
      attachmentType.hashCode;
}
