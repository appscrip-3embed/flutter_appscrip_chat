import 'dart:convert';
import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class IsmChatUtility {
  const IsmChatUtility._();

  static void dismissKeyBoard() {
    FocusScope.of(Get.context!).unfocus();
  }

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

  static Future<void> showErrorDialog(String message) async {
    await Get.dialog(
      IsmChatAlertDialogBox(
        title: message,
        cancelLabel: IsmChatStrings.ok,
      ),
    );
  }

  static Future<T?> openFullScreenBottomSheet<T>(Widget child) async =>
      await Get.bottomSheet<T>(
        child,
        isDismissible: false,
        isScrollControlled: true,
        ignoreSafeArea: false,
        enableDrag: false,
      );

  /// Returns true if the internet connection is available.
  static Future<bool> get isNetworkAvailable async =>
      await InternetConnectionChecker().hasConnection;

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

  static Future<File?> pickImage(ImageSource source) async {
    XFile? result;
    result = await ImagePicker().pickImage(imageQuality: 25, source: source);

    if (result == null) {
      return null;
    }
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: result.path,
      cropStyle: CropStyle.circle,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper'.tr,
          toolbarColor: IsmChatColors.blackColor,
          toolbarWidgetColor: IsmChatColors.whiteColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        )
      ],
    );
    return File(croppedFile!.path);
  }
}
