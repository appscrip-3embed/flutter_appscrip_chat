import 'package:chat_component/src/res/res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatUtility {
  static bool isLoaderOpen = Get.isDialogOpen ?? false;

  /// Show loader
  static void showLoader() async {
    if (!isLoaderOpen) {
      await Get.dialog<void>(
        Center(
          child: SizedBox(
            height: 60,
            width: 60,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: ChatTheme.of(Get.context!).primaryColor,
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void closeLoader() {
    if (isLoaderOpen) {
      Get.back(closeOverlays: true, canPop: false);
    }
  }
}
