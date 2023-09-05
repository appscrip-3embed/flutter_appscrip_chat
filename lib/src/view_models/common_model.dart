import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';

class IsmChatCommonViewModel {
  IsmChatCommonViewModel(this._repository);

  final IsmChatCommonRepository _repository;

  Future<int?> updatePresignedUrl({
    String? presignedUrl,
    Uint8List? bytes,
    bool isLoading = false,
  }) async {
    var respone = await _repository.updatePresignedUrl(
      presignedUrl: presignedUrl,
      bytes: bytes,
      isLoading: isLoading,
    );
    if (!respone!.hasError) {
      return respone.errorCode;
    }
    return null;
  }

  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async =>
      await _repository.getPresignedUrl(
        isLoading: isLoading,
        userIdentifier: userIdentifier,
        mediaExtension: mediaExtension,
      );
}
