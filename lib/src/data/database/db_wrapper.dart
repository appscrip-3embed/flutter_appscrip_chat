import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.
class IsmChatDBWrapper {
  IsmChatDBWrapper._create(this.collection);

  /// The Store of this presenter.
  late final BoxCollection collection;

  static const String _userBox = 'user';
  static const String _conversationBox = 'conversation';
  static const String _forwardBox = 'forward';
  static const String _pendingBox = 'pending';

  /// A Box of user Details.
  late final CollectionBox<Map> userDetailsBox;

  /// A Box of Pending message.
  late final CollectionBox<Map> pendingMessageBox;

  /// A Box of Forward Message box.
  late final CollectionBox<Map> forwardMessageBox;

  /// A Box of Conversation model
  late final CollectionBox<Map> chatConversationBox;

  Future<void> _createBox() async {
    var boxes = await Future.wait([
      collection.openBox<Map>(_userBox),
      collection.openBox<Map>(_conversationBox),
      collection.openBox<Map>(_pendingBox),
      collection.openBox<Map>(_forwardBox),
    ]);
    userDetailsBox = boxes[0];
    chatConversationBox = boxes[1];
    pendingMessageBox = boxes[2];
    forwardMessageBox = boxes[3];
  }

  /// Create an instance of ObjectBox to use throughout the presenter.
  static Future<IsmChatDBWrapper> create([String? databaseName]) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.

    var dbName = databaseName ?? IsmChatConfig.dbName;
    final collection = await BoxCollection.open(
      dbName,
      {
        _userBox,
        _conversationBox,
        _pendingBox,
        _forwardBox,
      },
    );

    var instance = IsmChatDBWrapper._create(collection);
    await instance._createBox();
    return instance;
  }

  /// delete chat object box
  Future<void> deleteChatLocalDb() async {
    await Future.wait([
      userDetailsBox.clear(),
      chatConversationBox.clear(),
      pendingMessageBox.clear(),
      forwardMessageBox.clear(),
      Get.find<IsmChatMqttController>().unSubscribe(),
      Get.find<IsmChatMqttController>().disconnect(),
    ]);

    IsmChatLog.success('[CLEARED] - All entries are removed from database');
  }

  ///  clear all messages for perticular user
  Future<void> clearAllMessage({required String conversationId}) async {
    await saveMessages(conversationId, []);
    if (Get.isRegistered<IsmChatPageController>()) {
      await Get.find<IsmChatPageController>().getMessagesFromDB(conversationId);
    }
  }

  Future<List<IsmChatConversationModel>> getAllConversations() async {
    var keys = await chatConversationBox.getAllKeys();
    var conversations = await chatConversationBox.getAll(keys);
    if (conversations.isEmpty) {
      return [];
    }
    return conversations
        .where((element) => element != null)
        .map(
            (e) => IsmChatConversationModel.fromMap(e! as Map<String, dynamic>))
        .toList();
  }

  Future<IsmChatConversationModel?> getConversation(
    String? conversationId,
  ) async {
    if (conversationId == null || conversationId.trim().isEmpty) {
      return null;
    }
    var map =
        await chatConversationBox.get(conversationId) as Map<String, dynamic>?;
    if (map == null) {
      return null;
    }
    return IsmChatConversationModel.fromMap(map);
  }

  Future<bool> _saveConversation(
    IsmChatConversationModel conversation,
  ) async {
    if (conversation.conversationId == null ||
        conversation.conversationId!.trim().isEmpty) {
      return false;
    }

    await chatConversationBox.put(
      conversation.conversationId!,
      conversation.toMap(),
    );
    return true;
  }

  Future<IsmChatMessageModel?> _getMessage(String? messageId,
      [bool isPendingBox = true]) async {
    if (messageId == null || messageId.trim().isEmpty) {
      return null;
    }
    Map<String, dynamic>? map;
    if (isPendingBox) {
      map = await pendingMessageBox.get(messageId) as Map<String, dynamic>?;
    } else {
      map = await forwardMessageBox.get(messageId) as Map<String, dynamic>?;
    }
    if (map == null) {
      return null;
    }
    return IsmChatMessageModel.fromMap(map);
  }

  Future<bool> _saveMessage(
    IsmChatMessageModel message, [
    bool isPendingBox = true,
  ]) async {
    if (message.messageId == null || message.messageId!.trim().isEmpty) {
      return false;
    }
    if (isPendingBox) {
      await pendingMessageBox.put(message.messageId!, message.toMap());
    } else {
      await forwardMessageBox.put(message.messageId!, message.toMap());
    }
    return true;
  }

  /// Create Db with user
  Future<void> createAndUpdateConversation(
    IsmChatConversationModel conversationModel,
  ) async {
    try {
      var resposne = await getAllConversations();
      if (resposne.isEmpty) {
        await chatConversationBox.put(
          conversationModel.conversationId!,
          conversationModel.toMap(),
        );
      } else {
        var conversation =
            await getConversation(conversationModel.conversationId);
        if (conversation == null) {
          await _saveConversation(conversation!);
          return;
        }
        conversation = conversation.copyWith(
          isGroup: conversationModel.isGroup,
          membersCount: conversationModel.membersCount,
          lastMessageDetails: conversationModel.lastMessageDetails,
          messagingDisabled: conversationModel.messagingDisabled,
          unreadMessagesCount: conversationModel.unreadMessagesCount,
          opponentDetails: conversationModel.opponentDetails,
          lastMessageSentAt: conversationModel.lastMessageSentAt,
          config: conversationModel.config,
          metaData: conversationModel.metaData,
        );
        await _saveConversation(conversation);
      }
    } catch (e, st) {
      IsmChatLog.error('$e \n$st');
    }
  }

  /// Add pending Message
  Future<void> addPendingMessage(IsmChatMessageModel messageModel) async {
    final chatPendingMessages =
        await getConversation(messageModel.conversationId);
    if (chatPendingMessages != null) {
      chatPendingMessages.messages.add(messageModel.toJson());
      await pendingMessageBox.put(chatPendingMessages);
    } else {
      var pendingMessageModel = PendingMessageModel(
        conversationId: messageModel.conversationId ?? '',
        messages: [messageModel.toJson()],
      );
      await pendingMessageBox.put(pendingMessageModel);
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
      await forwardMessageBox.put(chatForwardMessages);
    } else {
      var forwardMessageModel = ForwardMessageModel(
          conversationId: messageModel.conversationId ?? '',
          messages: [messageModel.toJson()]);
      await forwardMessageBox.put(forwardMessageModel);
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
        conversation.lastMessageDetails.target =
            conversation.lastMessageDetails.target!.copyWith(
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
      await chatConversationBox.put(conversation);
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
      await pendingMessageBox.put(conversationForPendingMessge);
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
      await forwardMessageBox.put(conversationForForwardMessge);
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
}
