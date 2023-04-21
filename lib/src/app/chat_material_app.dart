import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatApp extends StatelessWidget {
  IsmChatApp({
    super.key,
    required this.communicationConfig,
    required this.onChatTap,
    this.onCreateChatTap,
    this.showCreateChatIcon = false,
    this.chatTheme,
    this.chatDarkTheme,
    this.loadingDialog,
    this.databaseName,
    this.onSignOut,
    this.showAppBar = false,
  }) {
    assert(IsmChatConfig.isInitialized,
        'ChatObjectBox is not initialized\nYou are getting this error because the IsmChatObjectBox class is not initialized, to initialize ChatObjectBox class call AppscripChatComponent.initialize() before your runApp()');
    assert(
      (showCreateChatIcon && onCreateChatTap != null) || !showCreateChatIcon,
      'If showCreateChatIcon is set to true then a non null callback must be passed to onCreateChatTap parameter',
    );
    assert(
      (showAppBar && onSignOut != null) || (!showAppBar),
      'If showAppBar is set to true then a non-null callback must be passed to onSignOut parameter',
    );
    IsmChatConfig.dbName = databaseName ?? IsmChatStrings.dbname;
    IsmChatConfig.loadingDialog = loadingDialog;
    IsmChatConfig.communicationConfig = communicationConfig;
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatConfig.onChatTap = onChatTap;
  }

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [IsmChatCommunicationConfig]
  final IsmChatCommunicationConfig communicationConfig;

  final IsmChatThemeData? chatTheme;

  final IsmChatThemeData? chatDarkTheme;

  /// Opitonal field
  ///
  /// loadingDialog takes a widget which override the classic [CircularProgressIndicator], and will be shown incase of api call or loading something
  final Widget? loadingDialog;

  /// databaseName is to be provided if you want to specify some name for the local database file.
  ///
  /// If not provided `appscrip_chat_component` will be used by default
  final String? databaseName;

  /// Required parameter
  ///
  /// Primarily designed for nagivating to Message screen
  ///
  /// `onChatTap` takes a non-null callback function that takes 2 arguments in its parameter list
  ///
  /// ```dart
  /// void Function(BuildContext, IsmChatConversationModel) onChatTap;
  /// ```
  ///
  /// `IsmChatConversationModel` gives data of current chat, it could be used for local storage or state variables
  ///
  final void Function(BuildContext, IsmChatConversationModel) onChatTap;

  /// A callback for `navigating` to the create chat screen
  ///
  /// A non-null callback should be passed, if showCreateChatIcon is set to `true`
  final VoidCallback? onCreateChatTap;

  /// This signifies whether or not to show [FloatingActionButton] that will navigate to the create chat screen
  ///
  /// Defaults to `false`
  ///
  /// If set to `true`, then onCreateChatTap callback must be passed to `navigate` to the screen
  final bool showCreateChatIcon;

  final bool showAppBar;
  final VoidCallback? onSignOut;

  /// Call this function on SignOut to delete the data stored locally in the Local Database
  static void logout() {
    IsmChatConfig.objectBox.deleteChatLocalDb();
    Get.delete<IsmChatConversationsController>(force: true);
    Get.delete<IsmChatMqttController>(force: true);
  }

  /// This function can be used to directly go to chatting page and start chatting from anywhere in the app
  ///
  /// Follow the following steps :-
  /// 1. Navigate to the Screen/View where `IsmChatApp` is used as the root widget for `Chat` module
  /// 2. Call this function by providing all the required data (must add `await` keyword as this is a Future)
  ///
  /// * `userId` - UserID of the user coming from backend APIs (`Required`)
  /// * `name` - The name to be displayed (`Required`)
  /// * `email` - Email of the user (`Required`)
  /// * `profileImageUrl` - The image url of the user (`Optional`)
  /// * `duration` - The duration for which the loading dialog will be displayed, this is to make sure all the controllers and variables are initialized before executing any statement and/or calling the APIs for data. (default `Duration(milliseconds: 500)`)
  /// * `onNavigateToChat` - This function will be executed to navigate to the specific chat screen of the selected user. If not provided, the `onChatTap` callback will be used which is passed to `IsmChatApp`.
  static Future<void> chatFromOutside({
    String profileImageUrl = '',
    required String name,
    required String email,
    required String userId,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    assert(
      [name, email, userId].every((e) => e.isNotEmpty),
      '''Input Error: Please make sure that all required fields are filled out.
      Name, email, and userId cannot be empty.''',
    );

    await Future.delayed(const Duration(milliseconds: 100));

    IsmChatUtility.showLoader();

    await Future.delayed(duration);

    IsmChatUtility.closeLoader();

    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatConversationsBinding().dependencies();
    }
    var controller = Get.find<IsmChatConversationsController>();
    var conversationId = controller.getConversationId(userId);
    late IsmChatConversationModel conversation;
    if (conversationId.isEmpty) {
      var userDetails = UserDetails(
        userProfileImageUrl: profileImageUrl,
        userName: name,
        userIdentifier: email,
        userId: userId,
        online: false,
        lastSeen: 0,
      );
      conversation = IsmChatConversationModel(
        messagingDisabled: false,
        conversationImageUrl: profileImageUrl,
        isGroup: false,
        opponentDetails: userDetails,
        unreadMessagesCount: 0,
        lastMessageDetails: null,
        lastMessageSentAt: 0,
        membersCount: 1,
      );
    } else {
      conversation = controller.conversations
          .firstWhere((e) => e.conversationId == conversationId);
    }
    controller.navigateToMessages(conversation);

    (onNavigateToChat ?? IsmChatConfig.onChatTap)
        .call(Get.context!, conversation);
  }

  @override
  Widget build(BuildContext context) => IsmChatConversations(
        onChatTap: onChatTap,
        onCreateChatTap: onCreateChatTap,
        showCreateChatIcon: showCreateChatIcon,
        showAppBar: showAppBar,
        onSignOut: onSignOut,
      );
}
