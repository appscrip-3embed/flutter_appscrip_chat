class IsmChatUserConfig {
  const IsmChatUserConfig({
    required this.userToken,
    required this.userId,
    required this.userName,
    this.userEmail,
    this.userProfile,
    this.imageBaseUrl,
  });
  final String userToken;
  final String userId;
  final String userName;
  final String? userEmail;
  final String? userProfile;
  final String? imageBaseUrl;
}
