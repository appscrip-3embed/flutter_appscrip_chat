import 'dart:convert';

import 'package:appscrip_chat_component/src/models/user_details_model.dart';
import 'package:azlistview/azlistview.dart';
import 'package:get/get.dart';

class SelectedForwardUser extends ISuspensionBean {
  factory SelectedForwardUser.fromJson(String source) =>
      SelectedForwardUser.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SelectedForwardUser.fromMap(Map<String, dynamic> map) =>
      SelectedForwardUser(
          isUserSelected: map['isUserSelected'] as bool? ?? false,
          userDetails: map['userDetails'] != null
              ? UserDetails.fromMap(map['userDetails'] as Map<String, dynamic>)
              : UserDetails(
                  online: false,
                  userName: '',
                  lastSeen: 0,
                  userId: '',
                  userIdentifier: '',
                  userProfileImageUrl: '',
                ),
          isBlocked: map['isBlocked'] as bool? ?? false,
          tagIndex: map['tagIndex'] as String? ?? '');

  SelectedForwardUser({
    required bool isUserSelected,
    required this.userDetails,
    required this.isBlocked,
    this.tagIndex,
  }) : _isUserSelected = isUserSelected.obs;

  final RxBool _isUserSelected;
  final UserDetails userDetails;
  final bool isBlocked;
  String? tagIndex;

  bool get isUserSelected => _isUserSelected.value;
  set isUserSelected(bool value) => _isUserSelected.value = value;

  SelectedForwardUser copyWith({
    bool? isUserSelected,
    UserDetails? userDetails,
    bool? isBlocked,
    String? tagIndex,
  }) =>
      SelectedForwardUser(
          isUserSelected: isUserSelected ?? this.isUserSelected,
          userDetails: userDetails ?? this.userDetails,
          isBlocked: isBlocked ?? this.isBlocked,
          tagIndex: tagIndex ?? this.tagIndex);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'isUserSelected': isUserSelected,
        'userDetails': userDetails.toMap(),
        'isBlocked': isBlocked,
        'tagIndex': tagIndex
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'SelectedForwardUser(isUserSelected: $isUserSelected, userDetails: $userDetails, isBlocked: $isBlocked, tagIndex: $tagIndex)';

  @override
  bool operator ==(covariant SelectedForwardUser other) {
    if (identical(this, other)) return true;

    return other.isUserSelected == isUserSelected &&
        other.userDetails == userDetails &&
        other.isBlocked == isBlocked &&
        other.tagIndex == tagIndex;
  }

  @override
  int get hashCode =>
      isUserSelected.hashCode ^
      userDetails.hashCode ^
      isBlocked.hashCode ^
      tagIndex.hashCode;

  @override
  String getSuspensionTag() => tagIndex ?? '';
}
