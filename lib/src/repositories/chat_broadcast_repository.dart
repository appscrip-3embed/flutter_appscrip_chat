import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class IsmChatBroadcastRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<IsmChatResponseModel?> getBroadCast({
    required List<String> ids,
    required String customType,
    required String searchTag,
    required int sort,
    required int skip,
    required int limit,
    required bool sortByCustomType,
    required bool executionPending,
    bool isloading = false,
  }) async {
    try {
      var response = await _apiWrapper.get(
        IsmChatAPI.chatGroupCast,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isloading,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;

      return response;

      // return user;
    } catch (e, st) {
      IsmChatLog.error('updateUserDataError $e', st);
      return null;
    }
    return null;
  }
}
