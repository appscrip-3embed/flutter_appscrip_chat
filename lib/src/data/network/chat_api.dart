/// ChatAPI class is a singleton class
///
/// It  will be used for API endpoint constants
class IsmChatAPI {
  const IsmChatAPI._();

  static const String baseUrl = 'https://apis.isometrik.io';

  static const String user = '$baseUrl/chat/user';
  static const String userDetails = '$baseUrl/chat/user/details';
  static const String allUsers = '$baseUrl/chat/users';
  static const String updateUsers = '$baseUrl/chat/user';
  static const String authenticate = '$allUsers/authenticate';

  static const String chatConversation = '$baseUrl/chat/conversation';
  static const String chatConversationClear = '$chatConversation/clear';
  static const String chatConversationDelete = '$chatConversation/local';
  static const String getChatConversations = '$baseUrl/chat/conversations';
  static const String conversationDetails = '$chatConversation/details';
  static const String conversationSetting = '$chatConversation/settings';

  static const String getPublicAndOpenConversation =
      '${chatConversation}s/publicoropen';
  static const String observer = '$chatConversation/observer';
  static const String joinObserver = '$observer/join';
  static const String leaveObserver = '$observer/leave';
  static const String getObserver = '${observer}s';

  static const String conversationUnreadCount =
      '${chatConversation}s/unread/count';

  static const String conversationMembers = '$chatConversation/members';
  static const String eligibleMembers = '$chatConversation/eligible/members';
  static const String leaveConversation = '$chatConversation/leave';
  static const String joinConversation = '$chatConversation/join';
  static const String conversationAdmin = '$chatConversation/admin';
  static const String conversationTitle = '$chatConversation/title';
  static const String conversationImage = '$chatConversation/image';

  static const String blockUser = '$user/block';
  static const String unblockUser = '$user/unblock';
  static const String nonBlockUser = '$user/nonblock';

  static const String _profilePic = '$user/presignedurl';
  static const String updateProfilePic = '$_profilePic/update';
  static const String createProfilePic = '$_profilePic/create';

  static const String sendMessage = '$baseUrl/chat/message';
  static const String sendBroadcastMessage = '$baseUrl/chat/message/broadcast';
  static const String sendForwardMessage = '$baseUrl/chat/message/forward';

  static const String chatStatus = '$sendMessage/status';
  static const String readStatus = '$chatStatus/read';
  static const String deliverStatus = '$chatStatus/delivery';
  static const String chatMessages = '$baseUrl/chat/messages';

  static const String readAllMessages = '$chatMessages/read';
  static const String deleteMessagesForMe = '$chatMessages/self';
  static const String deleteMessages = '$chatMessages/everyone';
  static const String createPresignedurl = '$user/presignedurl/create';
  static const String presignedUrls = '$chatMessages/presignedurls';
  static const String chatMedia = '$baseUrl/chat/messages/presignedurls';

  static const String chatIndicator = '$baseUrl/chat/indicator';
  static const String typingIndicator = '$chatIndicator/typing';
  static const String deliveredIndicator = '$chatIndicator/delivered';
  static const String readIndicator = '$chatIndicator/read';
  static const String reacton = '$baseUrl/chat/reaction';
}
