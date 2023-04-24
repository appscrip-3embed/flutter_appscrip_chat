import 'dart:convert';

import 'package:appscrip_chat_component/src/models/user_details_model.dart';
import 'package:get/get.dart';

class SelectedForwardUser {
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
      );

  SelectedForwardUser({
    required bool isUserSelected,
    required this.userDetails,
  }) : _isUserSelected = isUserSelected.obs;

  final RxBool _isUserSelected;
  final UserDetails userDetails;

  bool get isUserSelected => _isUserSelected.value;
  set isUserSelected(bool value) => _isUserSelected.value = value;

  SelectedForwardUser copyWith({
    bool? isUserSelected,
    UserDetails? userDetails,
  }) =>
      SelectedForwardUser(
        isUserSelected: isUserSelected ?? this.isUserSelected,
        userDetails: userDetails ?? this.userDetails,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'isUserSelected': isUserSelected,
        'userDetails': userDetails.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'SelectedForwardUser(isUserSelected: $isUserSelected, userDetails: $userDetails)';

  @override
  bool operator ==(covariant SelectedForwardUser other) {
    if (identical(this, other)) return true;

    return other.isUserSelected == isUserSelected &&
        other.userDetails == userDetails;
  }

  @override
  int get hashCode => isUserSelected.hashCode ^ userDetails.hashCode;
}
