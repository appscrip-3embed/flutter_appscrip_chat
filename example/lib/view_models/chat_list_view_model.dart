import 'package:get/get.dart';

class ChatListViewModel extends GetxController {
  var chatSkip = 0;
  var chatLimit = 20;
  // Future<dynamic> getChatConversations() async {
  //   try {
  //     var response = await ApiWrapper.get(
  //       '${ChatAPI.getChatConversations}?skip=$chatSkip&limit=$chatLimit',
  //       headers: ChatUtility.tokenCommonHeader(),
  //     );
  //     return response;
  //   } catch (e, st) {
  //     ChatLog.error('GetChatConversations $e', st);
  //   }
  // }
}
