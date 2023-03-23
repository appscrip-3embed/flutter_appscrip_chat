import 'dart:convert';

import 'package:appscrip_chat_component/src/data/data.dart';
import 'package:appscrip_chat_component/src/models/models.dart';
import 'package:appscrip_chat_component/src/utilities/utilities.dart';

class ChatConversationsViewModel {
  var chatSkip = 0;
  var chatLimit = 20;
  Future<List<ChatConversationModel>?> getChatConversations() async {
    try {
      var response = await IsmChatApiWrapper.get(
        '${IsmChatAPI.getChatConversations}?skip=$chatSkip&limit=$chatLimit',
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
      var response = await IsmChatApiWrapper.get(
        IsmChatAPI.userDetails,
        headers: ChatUtility.tokenCommonHeader(),
      );
      if (response.hasError) {
        return null;
      }
      var data = jsonDecode(response.data) as Map<String, dynamic>;
      var user = UserDetails.fromMap(data);
      ChatLog(user);
      IsmChatConfig.objectBox.userDetailsBox.put(user);
      return user;
    } catch (e, st) {
      ChatLog.error('GetChatConversations $e', st);
      return null;
    }
  }

  Future<void> ismMessageDelivery(
      {required String conversationId, required String messageId}) async {
    try {
      var payload = {'messageId': messageId, 'conversationId': conversationId};
      var response = await IsmChatApiWrapper.put(
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

  Future<void> ismCreateConversation(
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
      var response = await IsmChatApiWrapper.post(
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
