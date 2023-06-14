import 'dart:convert';
import 'dart:typed_data';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
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

// / get Api for Presigned Url.....
  Future<PresignedUrl?> ismGetPresignedUrl(
      {required bool isLoading,
      required String userIdentifier,
      required String mediaExtension}) async {
    try {
      var response = await ApiWrapper.get(
        '${Api.presignedurl}?userIdentifier=$userIdentifier&mediaExtension=$mediaExtension',
        headers: Utility.commonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return PresignedUrl.fromMap(data);
    } catch (e) {
      return null;
    }
  }

// / get Api for Presigned Url.....
  Future<IsmChatResponseModel?> updatePresignedUrl(
      {required bool isLoading,
      required String presignedUrl,
      required Uint8List file}) async {
    try {
      var response = await ApiWrapper.put(
        presignedUrl,
        payload: file,
        headers: {},
        forAwsApi: true,
        showLoader: isLoading,
      );

      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<bool> postCreateUser(
      {required bool isLoading,
      required Map<String, dynamic> createUser}) async {
    try {
      var response = await ApiWrapper.post(
        Api.user,
        payload: createUser,
        headers: Utility.commonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return false;
      }
      var data = jsonDecode(response.data);

      var userDetails = UserDetailsModel(
        userId: data['userId'],
        userToken: data['userToken'],
        email: createUser['userIdentifier'],
      );
      objectBox.userDetailsBox.put(userDetails);
      return true;
    } catch (e, st) {
      AppLog.error('Sign up $e', st);
      return false;
    }
  }
}
