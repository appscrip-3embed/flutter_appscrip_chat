import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/utilities.dart';
import 'package:chat_component_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  final AuthViewModel _viewModel;
  AuthController(this._viewModel);

  var loginFormKey = GlobalKey<FormState>();
  var signFormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void validateLogin() {
    if (loginFormKey.currentState!.validate()) {
      login();
    }
  }

  Future<void> login() async {
    var data = await _viewModel.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (data != null) {
      unawaited(AppConfig.getUserData());

      Get.offAllNamed(AppRoutes.chatList, arguments: {'userData': data});
    }
  }

  void validateSignUp() {
    if (signFormKey.currentState!.validate()) {
      postCreateUser();
    }
  }

  final RxString _profileImage = ''.obs;
  String get profileImage => _profileImage.value;
  set profileImage(String value) {
    _profileImage.value = value;
  }

  final RxBool _isEmailValid = false.obs;
  bool get isEmailValid => _isEmailValid.value;
  set isEmailValid(bool value) {
    _isEmailValid.value = value;
  }

  Uint8List? bytes;

  void ismUploadImage(ImageSource imageSource) async {
    XFile? result;
    if (imageSource == ImageSource.gallery) {
      result = await ImagePicker()
          .pickImage(imageQuality: 25, source: ImageSource.gallery);
    } else {
      result = await ImagePicker().pickImage(
        imageQuality: 25,
        source: ImageSource.camera,
      );
    }
    if (result != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        cropStyle: CropStyle.circle,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper'.tr,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          )
        ],
      );
      bytes = File(croppedFile!.path).readAsBytesSync();
      var extension = result.name.split('.').last;
      await ismGetPresignedUrl(extension, bytes!);
    }
  }

  Future<void> postCreateUser() async {
    var creatUser = <String, dynamic>{
      'userProfileImageUrl': profileImage,
      'userName': userNameController.text.trim(),
      'userIdentifier': emailController.text.trim(),
      'password': confirmPasswordController.text.trim(),
      'metaData': {'country': 'India'}
    };
    var response =
        await _viewModel.postCreateUser(isLoading: true, createUser: creatUser);
    if (response) {
      Get.offNamed(AppRoutes.chatList);
    }
  }

  // / get Api for presigned Url.....
  Future<void> ismGetPresignedUrl(
      String mediaExtension, Uint8List bytes) async {
    var response = await _viewModel.ismGetPresignedUrl(
        isLoading: false,
        userIdentifier: emailController.text,
        mediaExtension: mediaExtension);
    if (response != null) {
      var urlResponse =
          await updatePresignedUrl(response.presignedUrl ?? '', bytes);
      if (urlResponse == 200) {
        profileImage = response.mediaUrl!;
      }
    }
  }

  /// put Api for updatePresignedUrl...
  Future<int?> updatePresignedUrl(String presignedUrl, Uint8List bytes) async {
    var response = await _viewModel.updatePresignedUrl(
        isLoading: false, presignedUrl: presignedUrl, file: bytes);
    if (response!.errorCode == 200) {
      return response.errorCode;
    } else {
      return 404;
    }
  }
}
