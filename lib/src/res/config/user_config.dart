class IsmChatUserConfig {
  const IsmChatUserConfig({
    required this.userToken,
    required this.userId,
    required this.userName,
    this.userEmail,
  });
  final String userToken;
  final String userId;
  final String userName;
  final String? userEmail;
}
