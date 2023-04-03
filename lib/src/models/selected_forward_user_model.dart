
import 'dart:convert';

import 'package:appscrip_chat_component/src/models/user_details_model.dart';

class SelectedForwardUser {

  factory SelectedForwardUser.fromJson(String source) =>
      SelectedForwardUser.fromMap(json.decode(source) as Map<String, dynamic>);

  factory SelectedForwardUser.fromMap(Map<String, dynamic> map) =>
      SelectedForwardUser(
        selectedUser:
            map['selectedUser'] != null ? map['selectedUser'] as bool : false,
        userDetails: map['userDetails'] != null
            ? UserDetails.fromMap(map['userDetails'] as Map<String, dynamic>)
            : UserDetails(
                online: false,
                userName: '',
                lastSeen: 0,
                userId: '',
                userIdentifier: '',
                userProfileImageUrl: ''),
      );
 SelectedForwardUser({
    required this.selectedUser,
    required this.userDetails,
  });
  bool selectedUser;
  UserDetails userDetails;

  SelectedForwardUser copyWith({
    bool? selectedUser,
    UserDetails? userDetails,
  }) =>
      SelectedForwardUser(
        selectedUser: selectedUser ?? this.selectedUser,
        userDetails: userDetails ?? this.userDetails,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'selectedUser': selectedUser,
        'userDetails': userDetails.toMap(),
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'SelectedForwardUser(selectedUser: $selectedUser, userDetails: $userDetails)';

  @override
  bool operator ==(covariant SelectedForwardUser other) {
    if (identical(this, other)) return true;

    return other.selectedUser == selectedUser &&
        other.userDetails == userDetails;
  }

  @override
  int get hashCode => selectedUser.hashCode ^ userDetails.hashCode;
}
