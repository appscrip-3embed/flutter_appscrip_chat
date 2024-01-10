import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatApp extends StatelessWidget {
  IsmChatApp({
    super.key,
    this.communicationConfig,
    this.chatPageProperties,
    this.conversationProperties,
    this.chatTheme,
    this.chatDarkTheme,
    this.loadingDialog,
    this.databaseName,
    this.enableGroupChat = false,
    this.useDataBase = true,
    this.noChatSelectedPlaceholder,
    this.sideWidgetWidth,
    this.isShowMqttConnectErrorDailog = false,
    this.fontFamily,
    this.conversationParser,
  }) {
    assert(IsmChatConfig.isInitialized,
        'ChatHiveBox is not initialized\nYou are getting this error because the Database class is not initialized, to initialize ChatHiveBox class call AppscripChatComponent.initialize() before your runApp()');
    assert(IsmChatConfig.configInitilized || communicationConfig != null,
        '''communicationConfig of type IsmChatCommunicationConfig must be initialized
    1. Either initialize using IsmChatApp.initializeMqtt() by passing  communicationConfig.
    2. Or Pass  communicationConfig in IsmChatApp
    ''');

    // assert(
    //   (showAppBar && onSignOut != null) || (!showAppBar),
    //   'If showAppBar is set to true then a non-null callback must be passed to onSignOut parameter',
    // );
    IsmChatConfig.dbName = databaseName ?? IsmChatStrings.dbname;
    IsmChatConfig.fontFamily = fontFamily;
    IsmChatConfig.conversationParser = conversationParser;
    IsmChatProperties.loadingDialog = loadingDialog;

    IsmChatProperties.sideWidgetWidth = sideWidgetWidth;
    IsmChatProperties.noChatSelectedPlaceholder = noChatSelectedPlaceholder;
    if (communicationConfig != null) {
      IsmChatConfig.communicationConfig = communicationConfig!;
      IsmChatConfig.configInitilized = true;
    }
    IsmChatConfig.useDatabase = useDataBase;
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.isShowMqttConnectErrorDailog = isShowMqttConnectErrorDailog;
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatProperties.isGroupChatEnabled = enableGroupChat;
    if (chatPageProperties != null) {
      IsmChatProperties.chatPageProperties = chatPageProperties!;
    }
    if (conversationProperties != null) {
      IsmChatProperties.conversationProperties = conversationProperties!;
    }
  }

  final bool isShowMqttConnectErrorDailog;

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [IsmChatCommunicationConfig]
  final IsmChatCommunicationConfig? communicationConfig;

  final IsmChatThemeData? chatTheme;

  final IsmChatThemeData? chatDarkTheme;

  final bool enableGroupChat;

  /// Opitonal field
  ///
  /// loadingDialog takes a widget which override the classic [CircularProgressIndicator], and will be shown incase of api call or loading something
  final Widget? loadingDialog;

  /// databaseName is to be provided if you want to specify some name for the local database file.
  ///
  /// If not provided `appscrip_chat_component` will be used by default
  final String? databaseName;

  final bool useDataBase;

  final IsmChatConversationProperties? conversationProperties;
  final IsmChatPageProperties? chatPageProperties;

  ///  It is showing you have no tap any converstaion
  final Widget? noChatSelectedPlaceholder;

  final double? sideWidgetWidth;

  final String? fontFamily;

  /// This callback is to be used if you want to make certain changes while conversation data is being parsed from the API
  final ConversationParser? conversationParser;

  /// Call this function for show outside widget
  ///
  ///  `You must use in web flow`
  ///
  ///  `You must call  outSideView callback widget in IsmChatConversationProperties`
  ///
  /// Don't use in mobile flow because this function work on web flow
  static void showThirdColumn() {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      final controller = Get.find<IsmChatConversationsController>();
      controller.isRenderChatPageaScreen = IsRenderChatPageScreen.outSideView;
    }
  }

  /// Call this function for close outside widget
  ///
  ///  `You must use in web flow `
  ///
  ///  `You must call  outSideView callback widget in IsmChatConversationProperties`
  ///
  /// Don't use in mobile flow because this function work on web flow
  static void clostThirdColumn() {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      final controller = Get.find<IsmChatConversationsController>();
      controller.isRenderChatPageaScreen = IsRenderChatPageScreen.none;
    }
  }

  /// Call this function for assign null on current conversation
  static void changeCurrentConversation() {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      final controller = Get.find<IsmChatConversationsController>();
      controller.currentConversation = null;
    }
  }

  /// Call this function for Get all Conversation List
  static void updateChatPageController() {
    if (Get.isRegistered<IsmChatPageController>()) {
      final controller = Get.find<IsmChatPageController>();
      var conversationModel = controller.conversation!;
      controller.conversation = null;
      controller.conversation = conversationModel;
    }
  }

  /// Call this function for Get all Conversation List from DB
  static Future<List<IsmChatConversationModel>?>
      getAllConversationFromDB() async {
    if (Get.isRegistered<IsmChatMqttController>()) {
      return await Get.find<IsmChatMqttController>().getAllConversationFromDB();
    }
    return null;
  }

  /// Call this funcation for get all conversation list with conversation predicate
  static Future<List<IsmChatConversationModel>> get userConversations =>
      getAllConversationFromDB().then((conversations) => (conversations ?? [])
          .where(
              IsmChatProperties.conversationProperties.conversationPredicate ??
                  (_) => true)
          .toList());

  /// Call this funcation for get all conversation unreadCount with predicate
  static Future<int> get unreadCount =>
      userConversations.then((value) => value.unreadCount);

  /// Call this function for update conversation Details in meta data
  static Future<void> updateConversation(
          {required String conversationId,
          required IsmChatMetaData metaData}) async =>
      await Get.find<IsmChatConversationsController>().updateConversation(
        conversationId: conversationId,
        metaData: metaData,
      );

  /// Call this function for update conversation setting in meta data
  static Future<void> updateConversationSetting({
    required String conversationId,
    required IsmChatEvents events,
    bool isLoading = false,
  }) async =>
      await Get.find<IsmChatConversationsController>()
          .updateConversationSetting(
        conversationId: conversationId,
        events: events,
        isLoading: isLoading,
      );

  /// Call this function for Get Conversation List with store local db When on click
  static Future<void> getChatConversation() async {
    if (Get.isRegistered<IsmChatConversationsController>()) {
      await Get.find<IsmChatConversationsController>().getChatConversations();
    }
  }

  /// Call this function for Get  conversations count
  /// You can call this funcation after MQTT controller intilized
  static Future<String> getChatConversationsCount({
    bool isLoading = false,
  }) async {
    if (Get.isRegistered<IsmChatMqttController>()) {
      return Get.find<IsmChatMqttController>()
          .getChatConversationsCount(isLoading: isLoading);
    }
    return '';
  }

  /// Call this function for unblock user form out side
  static Future<void> unblockUser({
    required String opponentId,
    bool includeMembers = false,
    bool isLoading = false,
    bool fromUser = false,
  }) async {
    if (Get.isRegistered<IsmChatPageController>()) {
      await Get.find<IsmChatPageController>().unblockUser(
        opponentId: opponentId,
        includeMembers: includeMembers,
        isLoading: isLoading,
        fromUser: fromUser,
        userBlockOrNot: true,
      );
    }
  }

  /// Call this function for block user form out side
  static Future<void> blockUser({
    required String opponentId,
    bool includeMembers = false,
    bool isLoading = false,
    bool fromUser = false,
  }) async {
    if (Get.isRegistered<IsmChatPageController>()) {
      await Get.find<IsmChatPageController>().blockUser(
        opponentId: opponentId,
        includeMembers: includeMembers,
        isLoading: isLoading,
        fromUser: fromUser,
        userBlockOrNot: false,
      );
    }
  }

  /// Call this function on SignOut to delete the data stored locally in the Local Database
  static void logout() async {
    await Get.find<IsmChatMqttController>().unSubscribe();
    await Get.find<IsmChatMqttController>().disconnect();
    await IsmChatConfig.dbWrapper?.deleteChatLocalDb();
    await Future.wait([
      Get.delete<IsmChatConversationsController>(force: true),
      Get.delete<IsmChatCommonController>(force: true),
      Get.delete<IsmChatMqttController>(force: true),
    ]);
  }

  /// Call this function on to delete chat with and local the data stored locally in the Local Database
  ///
  /// [deleteFromServer] - is a `boolean` parameter which signifies whether or not to delete the chat from server
  ///
  /// The chat will be deleted locally in all cases
  static Future<void> deleteChat(
    String conversationId, {
    bool deleteFromServer = true,
  }) async {
    assert(
      conversationId.isNotEmpty,
      '''Input Error: Please make sure that required fields are filled out.
      conversationId cannot be empty.''',
    );
    await Get.find<IsmChatConversationsController>().deleteChat(
      conversationId,
      deleteFromServer: deleteFromServer,
    );
  }

  /// Call this function on to delete chat the data stored locally in the Local Database
  ///
  /// The chat will be deleted locally in all cases
  static Future<bool> deleteChatFormDB(String isometrickChatId) async {
    assert(
      isometrickChatId.isNotEmpty,
      '''Input Error: Please make sure that required fields are filled out.
      isometrickChatId cannot be empty.''',
    );
    return await Get.find<IsmChatMqttController>().deleteChatFormDB(
      isometrickChatId,
    );
  }

  /// Call this funcation for the initialize mqtt
  static void initializeMqtt(
    IsmChatCommunicationConfig communicationConfig, {
    IsmChatThemeData? chatTheme,
    IsmChatThemeData? chatDarkTheme,
    Function(IsmChatMessageModel)? onSnckBarTap,
    bool isShowMqttConnectErrorDailog = false,
  }) {
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatConfig.communicationConfig = communicationConfig;
    IsmChatConfig.configInitilized = true;
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    IsmChatConfig.onSnckBarTap = onSnckBarTap;
    IsmChatConfig.isShowMqttConnectErrorDailog = isShowMqttConnectErrorDailog;
  }

  /// Call this funcation on to listener for mqtt events
  ///
  /// [IsmChatConfig.configInitilized] this variable must be true
  ///
  /// You can call this funcation after initialize mqtt [initializeMqtt] funcation
  static StreamSubscription<Map<String, dynamic>> addListener(
      Function(Map<String, dynamic>) listener) {
    assert(IsmChatConfig.configInitilized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChatApp.initializeMqtt() or add listener after IsmChatApp is called''');
    var mqttController = Get.find<IsmChatMqttController>();
    return mqttController.actionStreamController.stream.listen(listener);
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
    String? messageFromOutSide,
    bool? pushNotifications,
  }) async {
    assert(
      [name, userId].every((e) => e.isNotEmpty),
      '''Input Error: Please make sure that all required fields are filled out.
      Name, and userId cannot be empty.''',
    );

    IsmChatUtility.showLoader();

    await Future.delayed(duration);

    IsmChatUtility.closeLoader();

    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatCommonBinding().dependencies();
      IsmChatConversationsBinding().dependencies();
    }
    var controller = Get.find<IsmChatConversationsController>();
    var conversationId = controller.getConversationId(userId);
    IsmChatConversationModel? conversation;
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
          lastName: name.split(' ').last,
        ),
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
          metaData: metaData,
          messageFromOutSide: messageFromOutSide,
          pushNotifications: pushNotifications);
    } else {
      conversation = controller.conversations
          .firstWhere((e) => e.conversationId == conversationId);
      conversation = conversation.copyWith(
        metaData: metaData,
        messageFromOutSide: messageFromOutSide,
        pushNotifications: pushNotifications,
      );
    }

    (onNavigateToChat ?? IsmChatProperties.conversationProperties.onChatTap)
        ?.call(Get.context!, conversation);
    controller.navigateToMessages(conversation);
    await controller.goToChatPage();
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
    Duration duration = const Duration(milliseconds: 100),
    bool isShowLoader = true,
  }) async {
    if (isShowLoader) {
      IsmChatUtility.showLoader();

      await Future.delayed(duration);

      IsmChatUtility.closeLoader();
    }

    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatCommonBinding().dependencies();
      IsmChatConversationsBinding().dependencies();
    }

    var controller = Get.find<IsmChatConversationsController>();

    (onNavigateToChat ?? IsmChatProperties.conversationProperties.onChatTap)
        ?.call(Get.context!, ismChatConversation);
    controller.navigateToMessages(ismChatConversation);
    await controller.goToChatPage();
  }

  /// This variable use for store conversation unread count value
  /// This variable update when call api UnreadConverstaion on every action in chat
  static final RxString _unReadConversationMessages = ''.obs;
  static String get unReadConversationMessages =>
      _unReadConversationMessages.value;
  static set unReadConversationMessages(String value) =>
      _unReadConversationMessages.value = value;

  /// This variable use for mqtt connected or not
  /// This variable update when mqtt connection on app initlized
  static final RxBool _isMqttConnected = false.obs;
  static bool get isMqttConnected => _isMqttConnected.value;
  static set isMqttConnected(bool value) => _isMqttConnected.value = value;

  @override
  Widget build(BuildContext context) => const IsmChatConversations();
}
