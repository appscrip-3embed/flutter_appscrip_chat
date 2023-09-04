import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IsmChatCommonController extends GetxController {
  IsmChatCommonController(this._viewModel);
  final IsmChatCommonViewModel _viewModel;

  Future<int?> updatePresignedUrl(
          {String? presignedUrl, Uint8List? bytes}) async =>
      _viewModel.updatePresignedUrl(bytes: bytes, presignedUrl: presignedUrl);
}
