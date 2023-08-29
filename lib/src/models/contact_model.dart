// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class SelectedContact extends ISuspensionBean {
  final RxBool _isConotactSelected;
  final Contact contact;
  String? tagIndex;

  SelectedContact({
    required bool isConotactSelected,
    required this.contact,
    this.tagIndex,
  }) : _isConotactSelected = isConotactSelected.obs;

  bool get isConotactSelected => _isConotactSelected.value;
  set isConotactSelected(bool value) => _isConotactSelected.value = value;

  SelectedContact copyWith({
    bool? isConotactSelected,
    Contact? contact,
    String? tagIndex,
  }) =>
      SelectedContact(
        isConotactSelected: isConotactSelected ?? this.isConotactSelected,
        contact: contact ?? this.contact,
        tagIndex: tagIndex ?? this.tagIndex,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'isConotactSelected': isConotactSelected,
        'contact': contact.toMap(),
        'tagIndex': tagIndex,
      };

  factory SelectedContact.fromMap(Map<String, dynamic> map) => SelectedContact(
        isConotactSelected: map['isConotactSelected'] as bool? ?? false,
        contact: Contact.fromMap(map['contact'] as Map<String, dynamic>),
        tagIndex: map['tagIndex'] as String? ?? '',
      );

  String toJson() => json.encode(toMap());

  factory SelectedContact.fromJson(String source) =>
      SelectedContact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SelectedContact(isConotactSelected: $isConotactSelected, contact: $contact, tagIndex: $tagIndex)';

  @override
  bool operator ==(covariant SelectedContact other) {
    if (identical(this, other)) return true;

    return other.isConotactSelected == isConotactSelected &&
        other.contact == contact &&
        other.tagIndex == tagIndex;
  }

  @override
  int get hashCode =>
      isConotactSelected.hashCode ^ contact.hashCode ^ tagIndex.hashCode;

  @override
  String getSuspensionTag() => tagIndex ?? '';
}
