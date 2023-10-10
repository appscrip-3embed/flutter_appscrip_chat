// ignore_for_file: avoid_setters_without_getters

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:chat_component_example/main.dart';

import '../models/models.dart';

class AppConfig {
  const AppConfig._();

  static UserDetailsModel? userDetail;

  static Future<void> getUserData() async {
    var data = await dbWrapper!.userDetailsBox.get(IsmChatStrings.user);

    if (data == null) {
      return;
    }

    userDetail = UserDetailsModel.fromJson(data);
    IsmChatLog.error(userDetail?.userToken);
  }
}
