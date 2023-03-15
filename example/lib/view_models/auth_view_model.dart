import 'dart:convert';

import 'package:chat_component_example/data/network/network.dart';
import 'package:chat_component_example/main.dart';
import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:get/get.dart';

class AuthViewModel extends GetxController {
  Future<bool> login(String email, String password) async {
    try {
      var response = await ApiWrapper.post(
        Api.authenticate,
        payload: {'userIdentifier': email, 'password': password},
        headers: Utility.commonHeader(),
        showLoader: true,
      );

      if (response.hasError) {
        return false;
      }

      var data = jsonDecode(response.data);

      var userDetails = UserDetailsModel(
        userId: data['userId'],
        userToken: data['userToken'],
        email: email,
      );

      objectBox.userDetailsBox.put(userDetails);

      return true;
    } catch (e, st) {
      AppLog.error('Login $e', st);
      return false;
    }
  }
}
