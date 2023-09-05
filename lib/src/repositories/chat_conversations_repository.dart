import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

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
      IsmChatLog.error('GetUserList error $e', st);
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
      IsmChatLog.error('Get non block UserList error $e', st);
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
      listData.removeWhere((e) =>
          e.opponentDetails?.userId.isEmpty == true &&
          e.opponentDetails?.userName.isEmpty == true &&
          e.isGroup == false);
      return listData;
    } catch (e, st) {
      IsmChatLog.error('GetChatConversations error $e', st);
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
      IsmChatLog.error(' UnBlock user error $e', st);
      return null;
    }
  }

  Future<UserDetails?> getUserData({bool isLoading = false}) async {
    try {
      var response = await _apiWrapper.get(IsmChatAPI.userDetails,
          headers: IsmChatUtility.tokenCommonHeader(), showLoader: isLoading);
      if (response.hasError) {
        return null;
      }

      var data = jsonDecode(response.data) as Map<String, dynamic>;

      var user = UserDetails.fromMap(data);

      return user;
    } catch (e, st) {
      IsmChatLog.error('GetUserDataError $e', st);
      return null;
    }
  }

  Future<UserDetails?> updateUserData(Map<String, dynamic> metaData) async {
    try {
      var requestData = {'metaData': metaData};
      var response = await _apiWrapper.patch(
        IsmChatAPI.updateUsers,
        payload: requestData,
        headers: IsmChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = UserDetails.fromMap(data);
      return user;
    } catch (e, st) {
      IsmChatLog.error('updateUserDataError $e', st);
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
      IsmChatLog.error('Delete chat error $e', st);
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
      IsmChatLog.error('Clear chat error $e', st);
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
      IsmChatLog.error('Delivery Message error $e', st);
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
      IsmChatLog.error('GetChat Block users error $e', st);
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

  Future<IsmChatResponseModel?> sendForwardMessage(
      {required List<String> userIds,
      required bool showInConversation,
      required int messageType,
      required bool encrypted,
      required String deviceId,
      required String body,
      required String notificationBody,
      required String notificationTitle,
      List<String>? searchableTags,
      IsmChatMetaData? metaData,
      Map<String, dynamic>? events,
      String? customType,
      List<Map<String, dynamic>>? attachments,
      bool isLoading = false}) async {
    try {
      final payload = {
        'userIds': userIds,
        'showInConversation': showInConversation,
        'messageType': messageType,
        'encrypted': encrypted,
        'deviceId': deviceId,
        'body': body,
        'metaData': metaData?.toMap(),
        'events': events,
        'customType': customType,
        'attachments': attachments,
        'notificationBody': notificationBody,
        'notificationTitle': notificationTitle,
        'searchableTags': searchableTags,
      };

      var response = await _apiWrapper.post(
        IsmChatAPI.sendForwardMessage,
        payload: payload,
        headers: IsmChatUtility.tokenCommonHeader(),
        showLoader: isLoading,
      );
      if (response.hasError) {
        return null;
      }

      return response;
    } catch (e, st) {
      IsmChatLog.error('Send Forward Message $e', st);
      return null;
    }
  }

  Future<List<IsmChatConversationModel>?> getPublicConversation(
      {required int conversationType,
      String? searchTag,
      int sort = 1,
      int skip = 0,
      int limit = 20}) async {
    try {
      String? url;
      // if (searchTag?.isNotEmpty ?? false) {
      //   url =
      //       '${IsmChatAPI.getPublicConversation}?sort=$sort&skip=$skip&limit=$limit';
      // } else {
      //   url =
      //       '${IsmChatAPI.baseUrl}/chat/conversations/public?includeMembers=true';
      // }
      url =
          '${IsmChatAPI.baseUrl}/chat/conversations/publicoropen?conversationType=$conversationType';
      var response = await _apiWrapper.get(
        url,
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
      return listData;
    } catch (e, st) {
      IsmChatLog.error('GetUserList error $e', st);
      return null;
    }
  }

  Future<IsmChatResponseModel?> joinConversation(
      {required String conversationId, bool isLoading = false}) async {
    try {
      var payload = {'conversationId': conversationId};
      var response = await _apiWrapper.put(IsmChatAPI.joinConversation,
          payload: payload,
          headers: IsmChatUtility.tokenCommonHeader(),
          showLoader: isLoading);
      if (response.hasError) {
        return response;
      }
      return response;
    } catch (e, st) {
      IsmChatLog.error('Join conversation error $e', st);
      return null;
    }
  }
}
