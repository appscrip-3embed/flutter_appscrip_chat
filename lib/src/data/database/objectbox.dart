import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

export 'package:objectbox/objectbox.dart';
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

  List<IsmChatConversationModel> getAllConversations() {
    var conversations = chatConversationBox.getAll();
    if (conversations.isEmpty) {
      return [];
    }
    return conversations.map(IsmChatConversationModel.fromDB).toList();
  }

  /// delete chat object box
  void deleteChatLocalDb() async {
    userDetailsBox.removeAll();
    chatConversationBox.removeAll();
    pendingMessageBox.removeAll();
    forwardMessageBox.removeAll();
    await Get.find<IsmChatMqttController>().unSubscribe();
    await Get.find<IsmChatMqttController>().disconnect();
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
  Future<void> createAndUpdateDB(DBConversationModel dbConversation) async {
    try {
      var resposne = chatConversationBox.getAll();
      if (resposne.isEmpty) {
        chatConversationBox.put(dbConversation);
      } else {
        final query = chatConversationBox
            .query(DBConversationModel_.conversationId
                .equals(dbConversation.conversationId!))
            .build();
        final chatConversationResponse = query.findUnique();
        if (chatConversationResponse != null) {
          chatConversationResponse.isGroup = dbConversation.isGroup;
          chatConversationResponse.membersCount = dbConversation.membersCount;
          chatConversationResponse.lastMessageSentAt =
              dbConversation.lastMessageSentAt;
          chatConversationResponse.messagingDisabled =
              dbConversation.messagingDisabled;
          chatConversationResponse.unreadMessagesCount =
              dbConversation.unreadMessagesCount;
          chatConversationResponse.opponentDetails.target =
              dbConversation.opponentDetails.target;
          chatConversationResponse.lastMessageDetails.target =
              dbConversation.lastMessageDetails.target;
          chatConversationResponse.config.target = dbConversation.config.target;
          chatConversationResponse.metaData = dbConversation.metaData;
          chatConversationBox.put(chatConversationResponse);
        } else {
          chatConversationBox.put(dbConversation);
        }
      }
    } catch (e, st) {
      IsmChatLog.error('$e \n$st');
    }
  }

  /// Add pending Message
  Future<void> addPendingMessage(IsmChatMessageModel messageModel) async {
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
  Future<void> addForwardMessage(IsmChatMessageModel messageModel) async {
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

  Future<List<IsmChatMessageModel>?> getMessages(String? conversationId) async {
    if (conversationId == null) {
      return null;
    }
    var messages = <String>[];
    var conversationForPending = pendingMessageBox
        .query(PendingMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForPending != null) {
      messages.addAll(conversationForPending.messages);
    }
    var conversationForForward = forwardMessageBox
        .query(ForwardMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForForward != null) {
      messages.addAll(conversationForForward.messages);
    }
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation == null) {
      return null;
    } else {
      messages.addAll(conversation.messages);
    }
    return messages.map(IsmChatMessageModel.fromJson).toList();
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
    List<IsmChatMessageModel> messages,
  ) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation != null) {
      conversation.messages =
          messages.isEmpty ? [] : messages.map((e) => e.toJson()).toList();
      if (messages.isEmpty) {
        conversation.lastMessageDetails.target = LastMessageDetails(
          sentByMe: conversation.lastMessageDetails.target!.sentByMe,
          showInConversation:
              conversation.lastMessageDetails.target!.showInConversation,
          sentAt: DateTime.now().millisecondsSinceEpoch,
          senderName: conversation.lastMessageDetails.target!.senderName,
          messageType: 0,
          messageId: '',
          conversationId: conversationId,
          customType: conversation.lastMessageDetails.target!.customType,
          body: '',
        );
      }
      chatConversationBox.put(conversation);
      if (messages.isEmpty) {
        var conversationForPendingMessge = pendingMessageBox
            .query(PendingMessageModel_.conversationId.equals(conversationId))
            .build()
            .findUnique();
        if (conversationForPendingMessge != null) {
          pendingMessageBox.remove(conversationForPendingMessge.id);
        }
        var conversationForForwardMessge = forwardMessageBox
            .query(ForwardMessageModel_.conversationId.equals(conversationId))
            .build()
            .findUnique();
        if (conversationForForwardMessge != null) {
          forwardMessageBox.remove(conversationForForwardMessge.id);
        }
      }
    }
  }

  Future<void> removePendingMessage(
      String conversationId, List<IsmChatMessageModel> messages) async {
    var conversationForPendingMessge = pendingMessageBox
        .query(PendingMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForPendingMessge != null) {
      var pendingMessages = conversationForPendingMessge.messages
          .map(IsmChatMessageModel.fromJson)
          .toList();
      for (var x in messages) {
        pendingMessages.removeWhere((e) => e.sentAt == x.sentAt);
      }
      conversationForPendingMessge.messages =
          pendingMessages.map((e) => e.toJson()).toList();
      pendingMessageBox.put(conversationForPendingMessge);
    }
    var conversationForForwardMessge = forwardMessageBox
        .query(ForwardMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForForwardMessge != null) {
      var forwardMessages = conversationForForwardMessge.messages
          .map(IsmChatMessageModel.fromJson)
          .toList();
      for (var x in messages) {
        forwardMessages.removeWhere((e) => e.sentAt == x.sentAt);
      }
      conversationForForwardMessge.messages =
          forwardMessages.map((e) => e.toJson()).toList();
      forwardMessageBox.put(conversationForForwardMessge);
    }
  }

  Future<void> removeConversation(String conversationId) async {
    var conversation = chatConversationBox
        .query(DBConversationModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversation != null) {
      chatConversationBox.remove(conversation.id);
    }
    var conversationForPending = pendingMessageBox
        .query(PendingMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForPending != null) {
      pendingMessageBox.remove(conversationForPending.id);
    }
    var conversationForForward = forwardMessageBox
        .query(ForwardMessageModel_.conversationId.equals(conversationId))
        .build()
        .findUnique();
    if (conversationForForward != null) {
      forwardMessageBox.remove(conversationForForward.id);
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
