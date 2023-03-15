import 'dart:convert';

import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatUtility {
  const ChatUtility._();

  static bool isLoaderOpen = Get.isDialogOpen ?? false;

  /// Show loader
  static void showLoader() async {
    if (!isLoaderOpen) {
      await Get.dialog<void>(
        (ChatConstants.loadingDialog) ?? loadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  static Widget loadingDialog() => Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: Card(
            color: ChatTheme.of(Get.context!).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: ChatTheme.of(Get.context!).primaryColor,
              ),
            ),
          ),
        ),
      );

  static void closeLoader() {
    if (isLoaderOpen) {
      Get.back(closeOverlays: true, canPop: false);
    }
  }

  /// common header for All api
  static Map<String, String> commonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': ChatConstants.communicationConfig.licenseKey,
      'appSecret': ChatConstants.communicationConfig.appSecret,
      'userSecret': ChatConstants.communicationConfig.userSecret,
    };
    return header;
  }

  /// Token common Header for All api
  static Map<String, String> tokenCommonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': ChatConstants.communicationConfig.licenseKey,
      'appSecret': ChatConstants.communicationConfig.appSecret,
      'userToken': ChatConstants.communicationConfig.userToken,
    };
    return header;
  }

  /// this is for change encoded string to decode string
  static String decodePayload(String value) => utf8.fuse(base64).decode(value);

  /// this is for change decode string to encode string
  static String encodePayload(String value) => utf8.fuse(base64).encode(value);
}
