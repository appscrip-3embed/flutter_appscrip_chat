import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class IsmChatUtility {
  const IsmChatUtility._();

  // static bool isLoaderOpen = Get.isDialogOpen ?? false;

  /// Show loader
  static void showLoader() async {
    var isLoaderOpen = Get.isDialogOpen;
    if (isLoaderOpen != null) {
      await Get.dialog<void>(
        const IsmChatLoadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  static void closeLoader() {
    var isLoaderOpen = Get.isDialogOpen;
    if (isLoaderOpen != null) {
      Get.back(closeOverlays: false, canPop: true);
    }
  }

  static Future<T?> openFullScreenBottomSheet<T>(Widget child) async =>
      await Get.bottomSheet<T>(
        child,
        isDismissible: false,
        isScrollControlled: true,
        ignoreSafeArea: false,
        enableDrag: false,
      );

  /// common header for All api
  static Map<String, String> commonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.projectConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.projectConfig.appSecret,
      'userSecret': IsmChatConfig.communicationConfig.projectConfig.userSecret,
    };
    return header;
  }

  /// Token common Header for All api
  static Map<String, String> tokenCommonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.projectConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.projectConfig.appSecret,
      'userToken': IsmChatConfig.communicationConfig.userConfig.userToken,
    };
    return header;
  }

  /// this is for change encoded string to decode string
  static String decodePayload(String value) {
    try {
      return utf8.fuse(base64).decode(value);
    } catch (e) {
      IsmChatLog.error('Decode Error - $value');
      return value;
    }
  }

  /// this is for change decode string to encode string
  static String encodePayload(String value) => utf8.fuse(base64).encode(value);

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: IsmChatConfig.chatTheme.backgroundColor,
      textColor: IsmChatConfig.chatTheme.primaryColor,
      fontSize: 16.0,
    );
  }
}
