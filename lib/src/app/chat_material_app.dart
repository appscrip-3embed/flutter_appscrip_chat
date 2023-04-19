import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

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
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.fallback();
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.fallback();
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
  static void logout() => IsmChatConfig.objectBox.deleteChatLocalDb();

  @override
  Widget build(BuildContext context) => IsmChatConversations(
        onChatTap: onChatTap,
        onCreateChatTap: onCreateChatTap,
        showCreateChatIcon: showCreateChatIcon,
        showAppBar: showAppBar,
        onSignOut: onSignOut,
      );
}
