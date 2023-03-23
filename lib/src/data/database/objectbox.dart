import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
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
    ChatLog.success('[CREATED] - Objectbox databse at $_dbPath');
    return IsmChatObjectBox._create(store);
  }

  /// delete chat object box
  void deleteChatLocalDb() async {
    userDetailsBox.removeAll();
    chatConversationBox.removeAll();
    pendingMessageBox.removeAll();
    forwardMessageBox.removeAll();
    ChatLog.success('[CLEARED] - All entries are removed from database');
  }

  /// Create Db with user
  Future<void> createAndUpdateDB(
      {DBConversationModel? dbConversationModel}) async {
    var resposne = chatConversationBox.getAll();
    if (resposne.isEmpty) {
      chatConversationBox.put(dbConversationModel ?? DBConversationModel());
    } else {
      final query = chatConversationBox
          .query(DBConversationModel_.conversationId
              .equals(dbConversationModel!.conversationId!))
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
        ChatLog.info('update db');
      } else {
        chatConversationBox.put(dbConversationModel);
        ChatLog.info('add converstaion in db');
      }
    }
  }

  /// Add pending Message
  Future<void> addPendingMessage(DBMessageModel dbMessageModel) async {
    final query = pendingMessageBox
        .query(PendingMessageModel_.conversationId
            .equals(dbMessageModel.conversationId ?? ''))
        .build();
    final chatPendingMessages = query.findUnique(); 
    if (chatPendingMessages != null) {
      chatPendingMessages.messages.add(dbMessageModel);
      pendingMessageBox.put(chatPendingMessages);
    } else {
      var pendingMessageModel = PendingMessageModel(
          conversationId: dbMessageModel.conversationId ?? '');
      pendingMessageModel.messages.add(dbMessageModel);
      pendingMessageBox.put(pendingMessageModel);
    }
  }

  /// Add forward Message
  Future<void> addForwardMessage(DBMessageModel dbMessageModel) async {
    final query = forwardMessageBox
        .query(ForwardMessageModel_.conversationId
            .equals(dbMessageModel.conversationId ?? ''))
        .build();
    final chatForwardMessages = query.findUnique(); 
    if (chatForwardMessages != null) {
      chatForwardMessages.messages.add(dbMessageModel);
      forwardMessageBox.put(chatForwardMessages);
    } else {
      var forwardMessageModel = ForwardMessageModel(
          conversationId: dbMessageModel.conversationId ?? '');
      forwardMessageModel.messages.add(dbMessageModel);
      forwardMessageBox.put(forwardMessageModel);
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
      ChatLog.error('[ERROR] - ObjectBox create : $e');
      var directory = Directory(_dbPath);
      await directory.delete(recursive: true);
      ChatLog.info('[DELETED] - Database');
      return await _openStore();
    }
  }
}
