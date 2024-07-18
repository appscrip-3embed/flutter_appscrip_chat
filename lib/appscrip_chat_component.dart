library appscrip_chat_component;

import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/appscrip_chat_component_platform_interface.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

export 'src/app/app.dart';
export 'src/controllers/controllers.dart';
export 'src/data/data.dart';
export 'src/models/models.dart';
export 'src/repositories/repositories.dart';
export 'src/res/res.dart';
export 'src/utilities/utilities.dart';
export 'src/view_models/view_models.dart';
export 'src/views/views.dart';
export 'src/widgets/widgets.dart';

part 'appscrip_chat_component_delegate.dart';

class IsmChat {
  factory IsmChat() => instance;

  const IsmChat._(this._delegate);

  final IsmChatDelegate _delegate;

  static IsmChat i = const IsmChat._(IsmChatDelegate());

  static IsmChat instance = i;

  static bool _initialized = false;

  IsmChatConfig? get ismChatConfig => _delegate.ismChatConfig;

  IsmChatCommunicationConfig? get config {
    assert(
      _initialized,
      'IsmChat is not initialized, initialize it using IsmChat.initialize(config)',
    );
    return _delegate.config;
  }

  /// This variable use for store conversation unread count value
  /// This variable update when call api UnreadConverstaion on every action in chat
  String get unReadConversationMessages => _delegate.unReadConversationMessages;

  /// This variable use for mqtt connected or not
  /// This variable update when mqtt connection on app initlized
  bool get isMqttConnected => _delegate.isMqttConnected;

  Future<String?> getPlatformVersion() =>
      ChatComponentPlatform.instance.getPlatformVersion();

  Future<void> initialize(
    IsmChatCommunicationConfig communicationConfig, {
    bool useDatabase = true,
    String databaseName = IsmChatStrings.dbname,
    NotificaitonCallback? showNotification,
    BuildContext? context,
    bool shouldSetupMqtt = false,
  }) async {
    await _delegate.initialize(
      communicationConfig,
      useDatabase: useDatabase,
      showNotification: showNotification,
      context: context,
      databaseName: databaseName,
      shouldSetupMqtt: shouldSetupMqtt,
    );
    _initialized = true;
  }

  /// Call this function for Listen MQTT Evnet from OutSide
  /// [_initialized] this variable must be true
  /// You can call this funcation after MQTT controller intilized
  Future<void> listenMqttEvent({
    required Map<String, dynamic> data,
    NotificaitonCallback? showNotification,
  }) async {
    assert(_initialized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChat.initialize() or add listener after IsmChatApp is called''');
    await _delegate.listenMqttEvent(
        data: data, showNotification: showNotification);
  }

  /// Call this funcation on to listener for mqtt events
  ///
  /// [_initialized] this variable must be true
  ///
  /// You can call this funcation after initialize mqtt [initialize] funcation
  StreamSubscription<Map<String, dynamic>> addListener(
      Function(Map<String, dynamic>) listener) {
    assert(_initialized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChat.initialize() or add listener after IsmChat is called''');
    return _delegate.addListener(listener);
  }

  /// Call this funcation on to remove listener for mqtt events
  ///
  /// [_initialized] this variable must be true
  ///
  /// You can call this funcation after initialize mqtt [initialize] funcation
  Future<void> removeListener(Function(Map<String, dynamic>) listener) async {
    assert(_initialized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChat.initialize() or add listener after IsmChat is called''');
    await _delegate.removeListener(listener);
  }

  /// Call this funcation on to listener for mqtt events
  ///
  /// [_initialized] this variable must be true
  ///
  /// You can call this funcation after initialize mqtt [initialize] funcation
  StreamSubscription<EventModel> addEventListener(
      Function(EventModel) listener) {
    assert(_initialized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChat.initialize() or add listener after IsmChat is called''');
    return _delegate.addEventListener(listener);
  }

  /// Call this funcation on to remove listener for mqtt events
  ///
  /// [_initialized] this variable must be true
  ///
  /// You can call this funcation after initialize mqtt [initialize] funcation
  Future<void> removeEventListener(Function(EventModel) listener) async {
    assert(_initialized,
        '''MQTT Controller must be initialized before adding listener.
    Either call IsmChat.initialize() or add listener after IsmChat is called''');
    await _delegate.removeEventListener(listener);
  }

  /// Call this function for show outside widget
  ///
  ///  `You must use in web flow`
  ///
  ///  `You must call  outSideView callback widget in IsmChatConversationProperties`
  ///
  /// Don't use in mobile flow because this function work on web flow
  void showThirdColumn() => _delegate.showThirdColumn();

  /// Call this function for close outside widget
  ///
  ///  `You must use in web flow `
  ///
  ///  `You must call  outSideView callback widget in IsmChatConversationProperties`
  ///
  /// Don't use in mobile flow because this function work on web flow
  void clostThirdColumn() => _delegate.clostThirdColumn();

  /// Call this funcation for showing Block un Block Dialog
  void showBlockUnBlockDialog() => _delegate.showBlockUnBlockDialog();

  /// Call this function for assign null on current conversation
  void changeCurrentConversation() => _delegate.changeCurrentConversation();

  /// Call this function for Get all Conversation List
  void updateChatPageController() => _delegate.updateChatPageController();

  /// Call this function for Get all Conversation List from DB
  Future<List<IsmChatConversationModel>?> getAllConversationFromDB() async =>
      await _delegate.getAllConversationFromDB();

  /// Call this function for t all user List
  Future<List<SelectedMembers>?> getNonBlockUserList() async =>
      await _delegate.getNonBlockUserList();

  /// Call this funcation for get all conversation list with conversation predicate
  Future<List<IsmChatConversationModel>> get userConversations async =>
      await _delegate.userConversations;

  /// Call this funcation for get all conversation unreadCount with predicate
  Future<int> get unreadCount async => await _delegate.unreadCount;

  /// Call this function on SignOut to delete the data stored locally in the Local Database
  Future<void> logout() async => await _delegate.logout();

  /// Call this function for clear the data stored locally in the Local Database
  Future<void> clearChatLocalDb() async => _delegate.clearChatLocalDb();

  /// Call this function for Get Conversation List with store local db When on click
  Future<void> getChatConversation() async =>
      await _delegate.getChatConversation();

  /// Call this function for update conversation Details in meta data
  Future<void> updateConversation(
          {required String conversationId,
          required IsmChatMetaData metaData}) async =>
      await _delegate.updateConversation(
          conversationId: conversationId, metaData: metaData);

  /// Call this function for update conversation setting in meta data
  Future<void> updateConversationSetting({
    required String conversationId,
    required IsmChatEvents events,
    bool isLoading = false,
  }) async =>
      await _delegate.updateConversationSetting(
          conversationId: conversationId, events: events, isLoading: isLoading);

  /// Call this function for Get  conversations count
  /// You can call this funcation after intilized
  Future<int> getChatConversationsCount({
    bool isLoading = false,
  }) async =>
      await _delegate.getChatConversationsCount(isLoading: isLoading);

  /// Call this function for Get  conversations message count
  /// You can call this funcation after intilized
  Future<int> getChatConversationsMessageCount({
    bool isLoading = false,
    required String converationId,
    required List<String> senderIds,
    bool senderIdsExclusive = false,
    int lastMessageTimestamp = 0,
  }) async =>
      await _delegate.getChatConversationsMessageCount(
        converationId: converationId,
        senderIds: senderIds,
        isLoading: isLoading,
        lastMessageTimestamp: lastMessageTimestamp,
        senderIdsExclusive: senderIdsExclusive,
      );

  Future<IsmChatConversationModel?> getConverstaionDetails({
    required String conversationId,
    bool? includeMembers,
    bool isLoading = false,
  }) async =>
      await _delegate.getConverstaionDetails(
        conversationId: conversationId,
        isLoading: isLoading,
        includeMembers: includeMembers,
      );

  /// Call this function for unblock user form out side
  Future<void> unblockUser({
    required String opponentId,
    bool includeMembers = false,
    bool isLoading = false,
    bool fromUser = false,
  }) async =>
      await _delegate.unblockUser(
        opponentId: opponentId,
        includeMembers: includeMembers,
        isLoading: isLoading,
        fromUser: fromUser,
      );

  /// Call this function for block user form out side
  Future<void> blockUser({
    required String opponentId,
    required bool includeMembers,
    required bool isLoading,
    required bool fromUser,
  }) async =>
      await _delegate.blockUser(
        opponentId: opponentId,
        includeMembers: includeMembers,
        isLoading: isLoading,
        fromUser: fromUser,
      );

  /// Call this funcation for get messages for perticular conversation with api
  Future<List<IsmChatMessageModel>?> getMessagesFromApi({
    required String conversationId,
    required int lastMessageTimestamp,
    int limit = 20,
    int skip = 0,
    String? searchText,
    bool isLoading = false,
  }) async =>
      await _delegate.getMessagesFromApi(
        conversationId: conversationId,
        lastMessageTimestamp: lastMessageTimestamp,
        limit: limit,
        skip: skip,
        searchText: searchText,
        isLoading: isLoading,
      );

  /// Call this function on to delete chat with and local the data stored locally in the Local Database
  ///
  /// [deleteFromServer] - is a `boolean` parameter which signifies whether or not to delete the chat from server
  ///
  /// The chat will be deleted locally in all cases
  Future<void> deleteChat(
    String conversationId, {
    bool deleteFromServer = true,
  }) async {
    assert(
      conversationId.isNotEmpty,
      '''Input Error: Please make sure that required fields are filled out.
      conversationId cannot be empty.''',
    );
    await _delegate.deleteChat(conversationId,
        deleteFromServer: deleteFromServer);
  }

  /// Call this function on to delete chat the data stored locally in the Local Database
  ///
  /// The chat will be deleted locally in all cases
  Future<bool> deleteChatFormDB(String isometrickChatId) async {
    assert(
      isometrickChatId.isNotEmpty,
      '''Input Error: Please make sure that required fields are filled out.
      isometrickChatId cannot be empty.''',
    );
    return await _delegate.deleteChatFormDB(isometrickChatId);
  }

  /// Call this function on to Exit Group the data stored locally in the Local Database and server
  ///
  /// The chat will be deleted locally in all cases
  Future<void> exitGroup(
      {required int adminCount, required bool isUserAdmin}) async {
    await _delegate.exitGroup(adminCount: adminCount, isUserAdmin: isUserAdmin);
  }

  /// Call this function on to clearMessages the data stored locally in the Local Database and server
  ///
  /// The chat will be deleted locally in all cases
  Future<void> clearAllMessages(
    String conversationId, {
    bool fromServer = true,
  }) async {
    assert(
      conversationId.isNotEmpty,
      '''Input Error: Please make sure that required fields are filled out.
      conversationId cannot be empty.''',
    );
    await _delegate.clearAllMessages(conversationId, fromServer: fromServer);
  }

  /// This function can be used to directly go to chatting page and start chatting from anywhere in the app
  ///
  /// Follow the following steps :-
  /// 1. Navigate to the Screen/View where `IsmChatApp` is used as the root widget for `Chat` module
  /// 2. Call this function by providing all the required data (must add `await` keyword as this is a Future)
  ///
  /// * `userId` - UserID of the user coming from backend APIs (`Required`)
  /// * `name` - The name to be displayed (`Required`)
  /// * `userIdentifier` - UserIdentifier of the user (`Required`)
  /// * `profileImageUrl` - The image url of the user (`Optional`)
  /// * `duration` - The duration for which the loading dialog will be displayed, this is to make sure all the controllers and variables are initialized before executing any statement and/or calling the APIs for data. (default `Duration(milliseconds: 500)`)
  /// * `onNavigateToChat` - This function will be executed to navigate to the specific chat screen of the selected user. If not provided, the `onChatTap` callback will be used which is passed to `IsmChatApp`.
  Future<void> chatFromOutside({
    String profileImageUrl = '',
    required String name,
    required userIdentifier,
    required String userId,
    IsmChatMetaData? metaData,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 500),
    OutSideMessage? outSideMessage,
    String? storyMediaUrl,
    bool pushNotifications = true,
    bool isCreateGroupFromOutSide = false,
  }) async {
    assert(
      [name, userId].every((e) => e.isNotEmpty),
      '''Input Error: Please make sure that all required fields are filled out.
      Name, and userId cannot be empty.''',
    );

    await _delegate.chatFromOutside(
      name: name,
      userIdentifier: userIdentifier,
      userId: userId,
      duration: duration,
      isCreateGroupFromOutSide: isCreateGroupFromOutSide,
      outSideMessage: outSideMessage,
      metaData: metaData,
      onNavigateToChat: onNavigateToChat,
      profileImageUrl: profileImageUrl,
      pushNotifications: pushNotifications,
      storyMediaUrl: storyMediaUrl,
    );
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
  Future<void> chatFromOutsideWithConversation({
    required IsmChatConversationModel ismChatConversation,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 100),
    bool isShowLoader = true,
  }) async {
    await _delegate.chatFromOutsideWithConversation(
      ismChatConversation: ismChatConversation,
      duration: duration,
      isShowLoader: isShowLoader,
      onNavigateToChat: onNavigateToChat,
    );
  }

  /// This function can be used to directly go to chatting page and start group chat from anywhere in the app
  ///
  /// Follow the following steps :-
  /// 1. Navigate to the Screen/View where `IsmChatApp` is used as the root widget for `Chat` module
  /// 2. Call this function by providing all the required data (must add `await` keyword as this is a Future)
  ///
  /// * `userIds` - UserIDs of the user coming from backend APIs (`Required`)
  /// * `conversationTitle` - The conversationTitle to be displayed (`Required`)
  /// * `email` - Email of the user (`Required`)
  /// * `profileImageUrl` - The image url of the user (`Optional`)
  /// * `duration` - The duration for which the loading dialog will be displayed, this is to make sure all the controllers and variables are initialized before executing any statement and/or calling the APIs for data. (default `Duration(milliseconds: 500)`)
  /// * `onNavigateToChat` - This function will be executed to navigate to the specific chat screen of the selected user. If not provided, the `onChatTap` callback will be used which is passed to `IsmChatApp`.
  Future<void> createGroupFromOutside({
    required String conversationImageUrl,
    required String conversationTitle,
    required List<String> userIds,
    IsmChatConversationType conversationType = IsmChatConversationType.private,
    IsmChatMetaData? metaData,
    void Function(BuildContext, IsmChatConversationModel)? onNavigateToChat,
    Duration duration = const Duration(milliseconds: 500),
    bool pushNotifications = true,
  }) async {
    assert(
      conversationTitle.isNotEmpty && userIds.isNotEmpty,
      '''Input Error: Please make sure that all required fields are filled out.
      conversationTitle, and userIds cannot be empty.''',
    );
    await _delegate.createGroupFromOutside(
      conversationImageUrl: conversationImageUrl,
      conversationTitle: conversationTitle,
      userIds: userIds,
      conversationType: conversationType,
      duration: duration,
      metaData: metaData,
      onNavigateToChat: onNavigateToChat,
      pushNotifications: pushNotifications,
    );
  }
}
