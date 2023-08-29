import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

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

  static Future<T?> openFullScreenBottomSheet<T>(Widget child,
          {bool isDismissible = false,
          bool ignoreSafeArea = false,
          bool enableDrag = false,
          Color? backgroundColor,
          ShapeBorder? shape}) async =>
      await Get.bottomSheet<T>(child,
          isDismissible: isDismissible,
          isScrollControlled: true,
          ignoreSafeArea: ignoreSafeArea,
          enableDrag: enableDrag,
          backgroundColor: backgroundColor,
          shape: shape);

  /// Returns true if the internet connection is available.
  static Future<bool> get isNetworkAvailable async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }

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

  /// Returns text representation of a provided bytes value (e.g. 1kB, 1GB)
  static String formatBytes(int size, [int fractionDigits = 2]) {
    if (size <= 0) return '0 B';
    final multiple = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, multiple)).toStringAsFixed(fractionDigits)} ${[
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB'
    ][multiple]}';
  }

  /// Returns data size representation of a provided file
  static Future<String> fileToSize(File file) async {
    Uint8List? bytes;
    try {
      bytes = file.readAsBytesSync();
    } catch (_) {
      bytes = Uint8List.fromList(
          await File.fromUri(Uri.parse(file.path)).readAsBytes());
    }
    var dataSize = IsmChatUtility.formatBytes(
      int.parse(bytes.length.toString()),
    );
    return dataSize;
  }

  static Future<File> makeDirectoryWithUrl(
      {required String urlPath, required String fileName}) async {
    File? file;
    String? path;
    if (urlPath.isValidUrl) {
      final url = Uri.parse(urlPath);
      final response = await http.get(url);
      final bytes = response.bodyBytes;
      final documentsDir =
          (await path_provider.getApplicationDocumentsDirectory()).path;
      path = '$documentsDir/$fileName';
      if (!File(path).existsSync()) {
        file = File(path);
        await file.writeAsBytes(bytes);
      }
    } else {
      final documentsDir =
          (await path_provider.getApplicationDocumentsDirectory()).path;
      path = '$documentsDir/$fileName';
      if (!File(path).existsSync()) {
        file = File(path);
        try {
          final bytes = await file.readAsBytes();
          await file.writeAsBytes(bytes);
        } catch (_) {
          return File(urlPath);
        }
      }
    }
    if (file != null) {
      return file;
    }
    return File(path);
  }

  /// call function for permission for local storage
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  static Widget circularProgressBar(
          [Color? backgroundColor, Color? animatedColor]) =>
      DecoratedBox(
        decoration: BoxDecoration(
            color: backgroundColor?.withOpacity(.5),
            borderRadius: BorderRadius.circular(15)),
        child: CircularProgressIndicator(
          backgroundColor: animatedColor,
          valueColor: AlwaysStoppedAnimation(backgroundColor?.withOpacity(.5)),
        ),
      );
}
