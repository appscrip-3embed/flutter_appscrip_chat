import 'dart:convert';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';

class ChatConversationsRepository {
  final _apiWrapper = IsmChatApiWrapper();

  Future<List<ChatConversationModel>?> getChatConversations({
    required int skip,
    required int limit,
  }) async {
    try {
      var response = await _apiWrapper.get(
        '${IsmChatAPI.getChatConversations}?skip=$skip&limit=$limit',
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data);
      return (data['conversations'] as List)
          .map((e) => ChatConversationModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      ChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }

  Future<UserDetails?> getUserData() async {
    try {
      var response = await _apiWrapper.get(
        IsmChatAPI.userDetails,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
     
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = UserDetails.fromMap(data);
      IsmChatConfig.objectBox.userDetailsBox.put(user);
      return user;
    } catch (e, st) {
      ChatLog.error('GetChatConversations $e', st);
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
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Delivery Message $e', st);
    }
  }

  Future<void> createConversation(
      {required bool typingEvents,
      required bool readEvents,
      required bool pushNotifications,
      required List<String> members,
      required bool isGroup,
      required int conversationType,
      List<String>? searchableTags,
      Map<String, dynamic>? metaData,
      String? customType,
      String? conversationTitle,
      String? conversationImageUrl}) async {
    try {
      var payload = {
        'typingEvents': typingEvents,
        'readEvents': readEvents,
        'pushNotifications': pushNotifications,
        'members': members,
        'isGroup': isGroup,
        'conversationType': conversationType,
        'searchableTags': searchableTags,
        'metaData': metaData,
        'customType': customType,
        'conversationTitle': conversationTitle,
        'conversationImageUrl': conversationImageUrl
      };
      var response = await _apiWrapper.post(
        IsmChatAPI.chatConversation,
        payload: payload,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return;
      }
    } catch (e, st) {
      ChatLog.error('Create converstaion $e', st);
    }
  }
}
