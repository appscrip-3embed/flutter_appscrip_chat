import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IsmChatUtility {
  const IsmChatUtility._();

  static bool isLoaderOpen = Get.isDialogOpen ?? false;

  /// Show loader
  static void showLoader() async {
    if (!isLoaderOpen) {
      await Get.dialog<void>(
        (IsmChatConfig.loadingDialog) ?? const IsmChatLoadingDialog(),
        barrierDismissible: false,
      );
    }
  }

  static void closeLoader() {
    if (isLoaderOpen) {
      Get.back(closeOverlays: true, canPop: false);
    }
  }

  /// common header for All api
  static Map<String, String> commonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.appSecret,
      'userSecret': IsmChatConfig.communicationConfig.userSecret,
    };
    return header;
  }

  /// Token common Header for All api
  static Map<String, String> tokenCommonHeader() {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'licenseKey': IsmChatConfig.communicationConfig.licenseKey,
      'appSecret': IsmChatConfig.communicationConfig.appSecret,
      'userToken': IsmChatConfig.communicationConfig.userToken,
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

  /// Change timeStamp to time formate
  static List<dynamic> timeStampToString({int timeStampValue = 0}) {
    final timeStamp = DateTime.fromMillisecondsSinceEpoch(timeStampValue);
    final currentTime = DateTime.now();
    final currentDay = int.parse(DateFormat('d').format(currentTime));
    final currentDayFromStamp = int.parse(DateFormat('d').format(timeStamp));
    var timeFormate = <dynamic>[];
    if (currentDay == currentDayFromStamp) {
      timeFormate.add(DateFormat.jm().format(timeStamp));
      timeFormate.add(timeStampValue);
    } else if (((currentDay - currentDayFromStamp) == 1) ||
        (currentDayFromStamp == 31)) {
      timeFormate.add('Yesterday');
      timeFormate.add(timeStampValue);
    } else if (((currentDay - currentDayFromStamp) > 1) ||
        (currentDayFromStamp > currentDay)) {
      timeFormate.add(DateFormat('dd/MM/yyyy').format(timeStamp));
      timeFormate.add(timeStampValue);
    }
    return timeFormate;
  }
}
