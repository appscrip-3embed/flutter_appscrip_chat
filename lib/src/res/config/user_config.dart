class IsmChatUserConfig {
  const IsmChatUserConfig({
    required this.userToken,
    required this.userId,
    this.imageUrl,
  });
  final String userToken;
  final String userId;
  final String? imageUrl;
}
