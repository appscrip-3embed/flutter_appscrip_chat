import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';

class IsmChatCommonViewModel {
  IsmChatCommonViewModel(this._repository);

  final IsmChatCommonRepository _repository;

  Future<int?> updatePresignedUrl(
      {String? presignedUrl, Uint8List? bytes}) async {
    var respone = await _repository.updatePresignedUrl(
        presignedUrl: presignedUrl, bytes: bytes);
    if (!respone!.hasError) {
      return respone.errorCode;
    }
    return null;
  }
}
