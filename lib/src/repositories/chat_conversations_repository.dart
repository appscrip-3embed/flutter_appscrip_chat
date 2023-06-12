import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/services.dart';

class IsmChatConversationsRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<IsmChatUserListModel?> getUserList({
    String? pageToken,
    int? count,
  }) async {
    try {
      String? url;
      if (pageToken?.isNotEmpty ?? false) {
        url = '${IsmChatAPI.allUsers}?pageToken=$pageToken&count=$count';
      } else {
        url = IsmChatAPI.allUsers;
      }
      var response = await _apiWrapper.get(
        url,
        headers: IsmChatUtility.commonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = IsmChatUserListModel.fromMap(data);
      return user;
    } catch (e, st) {
      IsmChatLog.error('GetUserList $e', st);
      return null;
    }
  }

  Future<IsmChatUserListModel?> getNonBlockUserList({
    int sort = 1,
    int skip = 0,
    int limit = 20,
    String searchTag = '',
    bool isLoading = false,
  }) async {
    try {
      String? url;
      if (searchTag.isNotEmpty) {
        url =
            '${IsmChatAPI.nonBlockUser}?sort=$sort&skip=$skip&limit=$limit&searchTag=$searchTag';
      } else {
        url = '${IsmChatAPI.nonBlockUser}?sort=$sort&skip=$skip&limit=$limit';
      }
      var response = await _apiWrapper.get(
        url,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = IsmChatUserListModel.fromMap(data);

      return user;
    } catch (e, st) {
      IsmChatLog.error('Get non block UserList $e', st);
      return null;
    }
  }

  Future<List<IsmChatConversationModel>?> getChatConversations({
    required int skip,
    required int limit,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.getChatConversations}?skip=$skip&limit=$limit',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      var listData = (data['conversations'] as List)
          .map((e) =>
              IsmChatConversationModel.fromMap(e as Map<String, dynamic>))
          .toList();
      listData.sort(
        (a, b) => a.lastMessageDetails!.sentAt
            .compareTo(b.lastMessageDetails!.sentAt),
      );
      listData.removeWhere((e) => e.opponentDetails?.userId.isEmpty == true && e.opponentDetails?.userName.isEmpty == true);
      return listData;
    } catch (e, st) {
      IsmChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> unblockUser(
      {required String opponentId, required bool isLoading}) async {
    try {
      final payload = {'opponentId': opponentId};
      var response = await _apiWrapper.post(
        IsmChatAPI.unblockUser,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error(' un Block user $e', st);
      return null;
    }
  }

  Future<UserDetails?> getUserData() async {
    try {
      var response = await _apiWrapper.get(
        IsmChatAPI.userDetails,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }

      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = UserDetails.fromMap(data);
      IsmChatConfig.objectBox.userDetailsBox.put(user);
      return user;
    } catch (e, st) {
      IsmChatLog.error('GetUserData $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> deleteChat(String conversationId) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.chatConversationDelete}?conversationId=$conversationId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Delete chat $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> clearAllMessages({
    required String conversationId,
  }) async {
    try {
      var response = await _apiWrapper.delete(
        '${IsmChatAPI.chatConversationClear}?conversationId=$conversationId',
        payload: null,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Clear chat $e', st);
      return null;
    }
  }

  Future<void> pingMessageDelivered({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await _apiWrapper.put(
        IsmChatAPI.deliveredIndicator,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      IsmChatLog.error('Delivery Message $e', st);
    }
  }

  Future<IsmChatUserListModel?> getBlockUser(
      {required int? skip, required int limit}) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.blockUser}?skip=$skip&limit=$limit',
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = IsmChatUserListModel.fromMap(data);
      return user;
    } catch (e, st) {
      IsmChatLog.error('GetChat Block users $e', st);
      return null;
    }
  }

  // get Api for Presigned Url.....
  Future<PresignedUrlModel?> getPresignedUrl({
    required bool isLoading,
    required String userIdentifier,
    required String mediaExtension,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.createPresignedurl}?userIdentifier=$userIdentifier&mediaExtension=$mediaExtension',
        headers: IsmChatUtility.commonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return PresignedUrlModel.fromMap(data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

// update for Presigned Url.....
  Future<IsmChatResponseModel?> updatePresignedUrl({
    required bool isLoading,
    required String presignedUrl,
    required Uint8List file,
  }) async {
    try {
      var response = await _apiWrapper.put(
        presignedUrl,
        payload: file,
        headers: {},
        forAwsUpload: true,
        showLoader: isLoading,
      );

      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e) {
      return null;
    }
  }



  Future<IsmChatResponseModel?> updateConversation({
    required String conversationId,
    required IsmChatMetaData metaData,
    bool isLoading = false,
  }) async {
    try {
      var response = await _apiWrapper.patch(
        IsmChatAPI.conversationDetails,
        payload: {
          'conversationId': conversationId,
          'metaData': metaData.toMap()
        },
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading,
      );

      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e) {
      return null;
    }
  }
}
