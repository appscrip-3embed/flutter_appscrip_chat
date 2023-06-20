import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatApp extends StatelessWidget {
  IsmChatApp({
    super.key,
    this.communicationConfig,
    required this.onChatTap,
    this.onCreateChatTap,
    this.showCreateChatIcon = false,
    this.chatTheme,
    this.chatDarkTheme,
    this.loadingDialog,
    this.databaseName,
    this.onSignOut,
    this.showAppBar = false,
    this.enableGroupChat = false,
    this.createChatIcon,
    this.name,
    this.nameBuilder,
    this.profileImageUrl,
    this.profileImageBuilder,
    this.subtitle,
    this.subtitleBuilder,
    this.actions,
    this.endActions,
    this.onProfileWidget,
    this.isSlidableEnable,
    this.emptyConversationPlaceholder,
    this.allowDelete = false,
    this.useDataBase = true,
  }) {
    assert(IsmChatConfig.isInitialized,
        'ChatObjectBox is not initialized\nYou are getting this error because the Database class is not initialized, to initialize ChatObjectBox class call AppscripChatComponent.initialize() before your runApp()');
    assert(IsmChatConfig.configInitilized || communicationConfig != null,
        '''communicationConfig of type IsmChatCommunicationConfig must be initialized
    1. Either initialize using IsmChatApp.initializeMqtt() by passing  communicationConfig.
    2. Or Pass  communicationConfig in IsmChatApp
    ''');
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
    if (communicationConfig != null) {
      IsmChatConfig.communicationConfig = communicationConfig!;
      IsmChatConfig.configInitilized = true;
    }
    IsmChatConfig.useDatabase = !kIsWeb && useDataBase;
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatConfig.onChatTap = onChatTap;
    IsmChatConfig.isGroupChatEnabled = enableGroupChat;
  }

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [IsmChatCommunicationConfig]
  final IsmChatCommunicationConfig? communicationConfig;

  final IsmChatThemeData? chatTheme;

  final IsmChatThemeData? chatDarkTheme;

  final Widget? createChatIcon;

  final bool enableGroupChat;

  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      profileImageBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)?
      profileImageUrl;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      nameBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)? name;
  final Widget? Function(BuildContext, IsmChatConversationModel, String)?
      subtitleBuilder;
  final String Function(BuildContext, IsmChatConversationModel, String)?
      subtitle;

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

  final bool allowDelete;

  final Widget? Function(BuildContext, IsmChatConversationModel)?
      onProfileWidget;

  final List<IsmChatConversationAction>? actions;
  final List<IsmChatConversationAction>? endActions;

  final bool? Function(BuildContext, IsmChatConversationModel)?
      isSlidableEnable;
  final Widget? emptyConversationPlaceholder;

  final bool useDataBase;

  /// Call this function for Get all Conversation List
  static Future<List<IsmChatConversationModel>?> getAllConversation() async =>
      IsmChatConfig.dbWrapper?.getAllConversations();

  /// Call this function for update conversation Details in meta data
  static Future<void> updateConversation(
          {required String conversationId,
          required IsmChatMetaData metaData}) async =>
      await Get.find<IsmChatConversationsController>().updateConversation(
          conversationId: conversationId, metaData: metaData);

  /// Call this function for Get Conversation List When on click
  static Future<void> getChatConversation() async {
    await Get.find<IsmChatConversationsController>().getChatConversations();
  }

  /// Call this function on SignOut to delete the data stored locally in the Local Database
  static void logout() async {
    if (IsmChatConfig.useDatabase) {
      await Get.find<IsmChatMqttController>().unSubscribe();
      await Get.find<IsmChatMqttController>().disconnect();
    } else {
      await IsmChatConfig.dbWrapper?.deleteChatLocalDb();
    }
    await Future.wait([
      Get.delete<IsmChatConversationsController>(force: true),
      Get.delete<IsmChatMqttController>(force: true),
    ]);
  }

  /// Call this function on to delete chat the data stored locally in the Local Database
  ///
  /// [deleteFromServer] - is a `boolean` parameter which signifies whether or not to delete the chat from server
  ///
  /// The chat will be deleted locally in all cases
  static Future<void> deleteChat(
    String conversationId, {
    bool deleteFromServer = true,
  }) async =>
      await Get.find<IsmChatConversationsController>().deleteChat(
        conversationId,
        deleteFromServer: deleteFromServer,
      );

  static void initializeMqtt(IsmChatCommunicationConfig communicationConfig) {
    IsmChatConfig.communicationConfig = communicationConfig;
    IsmChatConfig.configInitilized = true;
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
  }

  static void addListener(Function(Map<String, dynamic>) listener) {
    assert(IsmChatConfig.configInitilized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChatApp.initializeMqtt() or add listener after IsmChatApp is called''');
    var mqttController = Get.find<IsmChatMqttController>();
    mqttController.actionStreamController.stream.listen(listener);
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
    String? email,
    required String userId,
    IsmChatMetaData? metaData,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    assert(
      [name, userId].every((e) => e.isNotEmpty),
      '''Input Error: Please make sure that all required fields are filled out.
      Name, and userId cannot be empty.''',
    );

    await Future.delayed(const Duration(milliseconds: 100));

    IsmChatUtility.showLoader();

    await Future.delayed(duration);

    IsmChatUtility.closeLoader();

    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatConversationsBinding().dependencies();
    }
    var controller = Get.find<IsmChatConversationsController>();
    Get.put(IsmChatDeviceConfig()).init();
    var conversationId = controller.getConversationId(userId);
    late IsmChatConversationModel conversation;
    if (conversationId.isEmpty) {
      var userDetails = UserDetails(
          userProfileImageUrl: profileImageUrl,
          userName: name,
          userIdentifier: email ?? '',
          userId: userId,
          online: false,
          lastSeen: 0,
          metaData: IsmChatMetaData(
              profilePic: profileImageUrl,
              firstName: name.split(' ').first,
              lastName: name.split(' ').last));
      conversation = IsmChatConversationModel(
        messagingDisabled: false,
        conversationImageUrl: profileImageUrl,
        isGroup: false,
        opponentDetails: userDetails,
        unreadMessagesCount: 0,
        lastMessageDetails: null,
        lastMessageSentAt: 0,
        membersCount: 1,
        metaData: metaData,
      );
    } else {
      conversation = controller.conversations
          .firstWhere((e) => e.conversationId == conversationId);
      conversation = conversation.copyWith(metaData: metaData);
    }
    controller.navigateToMessages(conversation);

    (onNavigateToChat ?? IsmChatConfig.onChatTap)
        .call(Get.context!, conversation);
  }

  /// This function can be used to directly go to chatting page and start chatting from anywhere in the app
  ///
  /// Follow the following steps :-
  /// 1. Navigate to the Screen/View where `IsmChatApp` is used as the root widget for `Chat` module
  /// 2. Call this function by providing all the required data (must add `await` keyword as this is a Future)
  ///
  /// * `ismChatConversation` - Conversation of the user coming from backend APIs (`Required`)
  /// * `duration` - The duration for which the loading dialog will be displayed, this is to make sure all the controllers and variables are initialized before executing any statement and/or calling the APIs for data. (default `Duration(milliseconds: 500)`)
  /// * `onNavigateToChat` - This function will be executed to navigate to the specific chat screen of the selected user. If not provided, the `onChatTap` callback will be used which is passed to `IsmChatApp`.
  static Future<void> chatFromOutsideWithConversation({
    required IsmChatConversationModel ismChatConversation,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    IsmChatUtility.showLoader();

    await Future.delayed(duration);

    IsmChatUtility.closeLoader();

    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatConversationsBinding().dependencies();
    }
    var controller = Get.find<IsmChatConversationsController>();
    controller.navigateToMessages(ismChatConversation);
    (onNavigateToChat ?? IsmChatConfig.onChatTap)
        .call(Get.context!, ismChatConversation);
  }

  static final RxString _unReadConversationMessages = ''.obs;
  static String get unReadConversationMessages =>
      _unReadConversationMessages.value;
  static set unReadConversationMessages(String value) =>
      _unReadConversationMessages.value = value;

  static final RxBool _isMqttConnected = false.obs;
  static bool get isMqttConnected => _isMqttConnected.value;
  static set isMqttConnected(bool value) => _isMqttConnected.value = value;

  @override
  Widget build(BuildContext context) => IsmChatConversations(
        onChatTap: onChatTap,
        onCreateChatTap: onCreateChatTap,
        showCreateChatIcon: showCreateChatIcon,
        showAppBar: showAppBar,
        onSignOut: onSignOut,
        isGroupChatEnabled: enableGroupChat,
        createChatIcon: createChatIcon,
        allowDelete: allowDelete,
        actions: actions,
        endActions: endActions,
        onProfileWidget: onProfileWidget,
        name: name,
        nameBuilder: nameBuilder,
        profileImageUrl: profileImageUrl,
        profileImageBuilder: profileImageBuilder,
        subtitle: subtitle,
        subtitleBuilder: subtitleBuilder,
        isSlidableEnable: isSlidableEnable,
        emptyConversationPlaceholder: emptyConversationPlaceholder,
      );
}
