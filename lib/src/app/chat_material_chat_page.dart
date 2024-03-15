import 'dart:async';
import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';

class IsmMaterialChatPage extends StatefulWidget {
  IsmMaterialChatPage({
    super.key,
    this.communicationConfig,
    this.chatPageProperties,
    this.chatTheme,
    this.chatDarkTheme,
    this.loadingDialog,
    this.databaseName,
    this.enableGroupChat = false,
    this.useDataBase = true,
    this.isShowMqttConnectErrorDailog = false,
    this.useAlice,
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

    IsmChatConfig.dbName = databaseName ?? IsmChatStrings.dbname;
    IsmChatConfig.useAlice = useAlice;
    IsmChatConfig.fontFamily = fontFamily;
    IsmChatConfig.conversationParser = conversationParser;
    IsmChatProperties.loadingDialog = loadingDialog;
    IsmChatConfig.useDatabase = useDataBase;
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.isShowMqttConnectErrorDailog = isShowMqttConnectErrorDailog;
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatProperties.isGroupChatEnabled = enableGroupChat;
    if (communicationConfig != null) {
      IsmChatConfig.communicationConfig = communicationConfig!;
      IsmChatConfig.configInitilized = true;
    }
    if (chatPageProperties != null) {
      IsmChatProperties.chatPageProperties = chatPageProperties!;
    }
  }

  /// Required field
  ///
  /// This class takes sevaral parameters which are necessary to establish connection between `host` & `application`
  ///
  /// For details see:- [IsmChatCommunicationConfig]
  final IsmChatCommunicationConfig? communicationConfig;

  final IsmChatThemeData? chatTheme;

  final IsmChatThemeData? chatDarkTheme;

  final bool enableGroupChat;

  final bool useDataBase;

  final IsmChatPageProperties? chatPageProperties;

  final String? fontFamily;

  final bool isShowMqttConnectErrorDailog;

  final Alice? useAlice;

  /// Opitonal field
  ///
  /// loadingDialog takes a widget which override the classic [CircularProgressIndicator], and will be shown incase of api call or loading something
  final Widget? loadingDialog;

  /// databaseName is to be provided if you want to specify some name for the local database file.
  ///
  /// If not provided `appscrip_chat_component` will be used by default
  final String? databaseName;

  /// This callback is to be used if you want to make certain changes while conversation data is being parsed from the API
  final ConversationParser? conversationParser;

  /// Call this funcation for showing Block un Block Dialog
  static void showBlockUnBlockDialog() {
    if (Get.isRegistered<IsmChatPageController>()) {
      final controller = Get.find<IsmChatPageController>();
      if (!(controller.conversation?.isChattingAllowed == true)) {
        controller.showDialogCheckBlockUnBlock();
      }
    }
  }

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
  static Future<void> logout() async {
    await Get.find<IsmChatMqttController>().unSubscribe();
    await Get.find<IsmChatMqttController>().disconnect();
    await IsmChatConfig.dbWrapper?.deleteChatLocalDb();
    await Future.wait([
      Get.delete<IsmChatConversationsController>(force: true),
      Get.delete<IsmChatCommonController>(force: true),
      Get.delete<IsmChatMqttController>(force: true),
    ]);
  }

  /// Call this function for clear the data stored locally in the Local Database
  static Future<void> clearChatLocalDb() async {
    await IsmChatConfig.dbWrapper?.clearChatLocalDb();
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
    String? notificationIconPath,
    void Function(
      String,
      String,
      String,
    )? showNotification,
    bool isShowMqttConnectErrorDailog = false,
    Alice? useAlice,
  }) {
    IsmChatConfig.useAlice = useAlice;
    IsmChatConfig.chatLightTheme = chatTheme ?? IsmChatThemeData.light();
    IsmChatConfig.chatDarkTheme =
        chatDarkTheme ?? chatTheme ?? IsmChatThemeData.dark();
    IsmChatConfig.communicationConfig = communicationConfig;
    IsmChatConfig.configInitilized = true;
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    IsmChatConfig.showNotification = showNotification;
    IsmChatConfig.notificationIconPath = notificationIconPath;
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
  State<IsmMaterialChatPage> createState() => _IsmMaterialChatPageState();
}

class _IsmMaterialChatPageState extends State<IsmMaterialChatPage> {
  
  @override
  void initState() {
    super.initState();
    startInit();
  }

  startInit() {
    if (!Get.isRegistered<IsmChatMqttController>()) {
      IsmChatMqttBinding().dependencies();
    }
    if (!Get.isRegistered<IsmChatConversationsController>()) {
      IsmChatCommonBinding().dependencies();
      IsmChatConversationsBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) => const IsmChatPageView();
}
