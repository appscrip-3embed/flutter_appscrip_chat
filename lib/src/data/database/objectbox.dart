import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.
class IsmChatObjectBox {
  IsmChatObjectBox._create(this.store) {
    userDetailsBox = Box<UserDetails>(store);
    chatConversationBox = Box<DBConversationModel>(store);
    pendingMessageBox = Box<PendingMessageModel>(store);
    forwardMessageBox = Box<ForwardMessageModel>(store);
  }

  static late final String _dbPath;

  /// The Store of this presenter.
  late final Store store;

  /// A Box of user Details.
  late final Box<UserDetails> userDetailsBox;

  /// A Box of Pending message.
  late final Box<PendingMessageModel> pendingMessageBox;

  /// A Box of Forward Message box.
  late final Box<ForwardMessageModel> forwardMessageBox;

  /// A Box of Conversation model
  late final Box<DBConversationModel> chatConversationBox;

  // static Query<UserMessage> query = noteBox.query(UserMessage_.conversationId.equals())

  static Future<IsmChatObjectBox> _openStore() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    final store = await openStore(directory: _dbPath);
    IsmChatLog.success('[CREATED] - Objectbox databse at $_dbPath');
    return IsmChatObjectBox._create(store);
  }

  /// delete chat object box
  void deleteChatLocalDb() async {
    userDetailsBox.removeAll();
    chatConversationBox.removeAll();
    pendingMessageBox.removeAll();
    forwardMessageBox.removeAll();
    IsmChatLog.success('[CLEARED] - All entries are removed from database');
  }

  ///  clear all messages for perticular user
  Future<void> clearAllMessage({required String conversationId}) async {
    await saveMessages(conversationId, []);
    if (Get.isRegistered<IsmChatPageController>()) {
      await Get.find<IsmChatPageController>().getMessagesFromDB(conversationId);
    }
  }

  /// Create Db with user
  Future<void> createAndUpdateDB(
      {required DBConversationModel dbConversationModel}) async {
    var resposne = chatConversationBox.getAll();
    if (resposne.isEmpty) {
      chatConversationBox.put(dbConversationModel);
    } else {
      final query = chatConversationBox
          .query(DBConversationModel_.conversationId
              .equals(dbConversationModel.conversationId!))
          .build();
      final chatConversationResponse = query.findUnique();

      if (chatConversationResponse != null) {
        chatConversationResponse.isGroup = dbConversationModel.isGroup;
        chatConversationResponse.membersCount =
            dbConversationModel.membersCount;
        chatConversationResponse.lastMessageSentAt =
            dbConversationModel.lastMessageSentAt;
        chatConversationResponse.messagingDisabled =
            dbConversationModel.messagingDisabled;
        chatConversationResponse.unreadMessagesCount =
            dbConversationModel.unreadMessagesCount;
        chatConversationResponse.opponentDetails.target =
            dbConversationModel.opponentDetails.target;
        chatConversationResponse.lastMessageDetails.target =
            dbConversationModel.lastMessageDetails.target;
        chatConversationResponse.config.target =
            dbConversationModel.config.target;
        chatConversationBox.put(chatConversationResponse);
      } else {
        chatConversationBox.put(dbConversationModel);
      }
    }
  }

  /// Add pending Message
  Future<void> addPendingMessage(IsmChatChatMessageModel messageModel) async {
  
    final query = pendingMessageBox
        .query(PendingMessageModel_.conversationId
            .equals(messageModel.conversationId ?? ''))
        .build();
    final chatPendingMessages = query.findUnique();
    if (chatPendingMessages != null) {
      chatPendingMessages.messages.add(messageModel.toJson());
      pendingMessageBox.put(chatPendingMessages);
    } else {
      var pendingMessageModel = PendingMessageModel(
        conversationId: messageModel.conversationId ?? '',
        messages: [messageModel.toJson()],
      );
      pendingMessageBox.put(pendingMessageModel);
    }
  }

  /// Add forward Message
  Future<void> addForwardMessage(IsmChatChatMessageModel messageModel) async {
    final query = forwardMessageBox
        .query(ForwardMessageModel_.conversationId
            .equals(messageModel.conversationId ?? ''))
        .build();
    final chatForwardMessages = query.findUnique();
    if (chatForwardMessages != null) {
      chatForwardMessages.messages.add(messageModel.toJson());
      forwardMessageBox.put(chatForwardMessages);
    } else {
      var forwardMessageModel = ForwardMessageModel(
          conversationId: messageModel.conversationId ?? '',
          messages: [messageModel.toJson()]);
      forwardMessageBox.put(forwardMessageModel);
    }
  }

  Future<List<IsmChatChatMessageModel>?> getMessages(
      String conversationId) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation == null) {
      return null;
    }
    return conversation.messages.map(IsmChatChatMessageModel.fromJson).toList();
  }

  Future<DBConversationModel?> getDBConversation(
      {required String conversationId}) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation == null) {
      return null;
    }
    return conversation;
  }

  Future<void> saveMessages(
    String conversationId,
    List<IsmChatChatMessageModel> messages,
  ) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation != null) {
      conversation.messages =
          messages.isEmpty ? [] : messages.map((e) => e.toJson()).toList();
      chatConversationBox.put(conversation);
    }
  }

  Future<void> removeUser(String conversationId) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation != null) {
      chatConversationBox.remove(conversation.id);
    }
  }

  /// Create an instance of ObjectBox to use throughout the presenter.
  static Future<IsmChatObjectBox> create([String? databaseName]) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    try {
      var dbName = databaseName ?? IsmChatConfig.dbName;
      var docDir = await getApplicationDocumentsDirectory();
      _dbPath = '${docDir.path}/$dbName';
      return await _openStore();
    } on ObjectBoxException catch (e) {
      IsmChatLog.error('[ERROR] - ObjectBox create : $e');
      var directory = Directory(_dbPath);
      await directory.delete(recursive: true);
      IsmChatLog.info('[DELETED] - Database');
      return await _openStore();
    }
  }
}
