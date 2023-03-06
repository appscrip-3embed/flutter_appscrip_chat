/// ChatAPI class is a singleton class
///
/// It  will be used for API endpoint constants
class ChatAPI {
  const ChatAPI._();

  static const String baseUrl = 'https://apis.isometrik.io';

  static const String allUsers = '/chat/users';
  static const String user = '/chat/user';

  static const String chatConversations = '/chat/conversations';
  static const String conversationDetails = '/chat/conversations/details';

  static const String blockUser = '$user/block';
  static const String unblockUser = '$user/unblock';
  static const String nonblockUser = '$user/nonblock';

  static const String _profilePic = '$user/presignedurl';
  static const String updateProfilePic = '$_profilePic/update';
  static const String createProfilePic = '$_profilePic/create';

  static const String sendMessage = '/chat/message';
  static const String chatMessages = '/chat/messages';
  static const String chatMedia = '/chat/messages/presignedurls';
}
