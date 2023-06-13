import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.

typedef IsmChatMessageBoxType = List<Map<String, dynamic>>;
typedef IsmChatConversationTypeMap = Map<String, dynamic>;

class IsmChatDBWrapper {
  IsmChatDBWrapper._create(this.collection);

  /// The Store of this presenter.
  late final BoxCollection collection;

  static const String _userBox = 'user';
  static const String _conversationBox = 'conversation';
  static const String _forwardBox = 'forward';
  static const String _pendingBox = 'pending';

  /// A Box of user Details.
  late final CollectionBox<IsmChatConversationTypeMap> userDetailsBox;

  /// A Box of Pending message.
  late final CollectionBox<IsmChatMessageBoxType> pendingMessageBox;

  /// A Box of Forward Message box.
  late final CollectionBox<IsmChatMessageBoxType> forwardMessageBox;

  /// A Box of Conversation model
  late final CollectionBox<IsmChatConversationTypeMap> chatConversationBox;

  Future<void> _createBox() async {
    var data = await Future.wait<dynamic>([
      Future.wait([
        collection.openBox<IsmChatConversationTypeMap>(_userBox),
        collection.openBox<IsmChatConversationTypeMap>(_conversationBox),
      ]),
      Future.wait([
        collection.openBox<IsmChatMessageBoxType>(_pendingBox),
        collection.openBox<IsmChatMessageBoxType>(_forwardBox),
      ]),
    ]);
    var boxes = data[0] as List<CollectionBox<IsmChatConversationTypeMap>>;
    var boxes2 = data[1] as List<CollectionBox<IsmChatMessageBoxType>>;
    userDetailsBox = boxes[0];
    chatConversationBox = boxes[1];
    pendingMessageBox = boxes2[2];
    forwardMessageBox = boxes2[3];
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
    var conversation = await getConversation(conversationId: conversationId);
    if (conversation != null) {
      conversation.copyWith(messages: []);
      await saveConversation(conversation: conversation);
    }
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
        .map((e) => IsmChatConversationModel.fromMap(e!))
        .toList();
  }

  Future<IsmChatConversationModel?> getConversation({
    String? conversationId,
    IsmChatDbBox dbBox = IsmChatDbBox.main,
  }) async {
    if (conversationId == null || conversationId.trim().isEmpty) {
      return null;
    }
    Map<String, dynamic>? map;
    List<Map<String, dynamic>>? listMap;
    switch (dbBox) {
      case IsmChatDbBox.main:
        map = await chatConversationBox.get(conversationId);
        break;
      case IsmChatDbBox.pending:
        listMap = await pendingMessageBox.get(conversationId);
        break;
      case IsmChatDbBox.forward:
        listMap = await forwardMessageBox.get(conversationId);
        break;
    }
    if (dbBox == IsmChatDbBox.main) {
      if (map == null) {
        return null;
      }
      return IsmChatConversationModel.fromMap(map);
    }
    if (listMap == null || listMap.isEmpty) {
      return null;
    }
    var conversation = IsmChatConversationModel(
      conversationId: conversationId,
      messages: listMap.map(IsmChatMessageModel.fromMap).toList(),
    );
    return conversation;
  }

  Future<bool> saveConversation({
    required IsmChatConversationModel conversation,
    IsmChatDbBox dbBox = IsmChatDbBox.main,
  }) async {
    if (conversation.conversationId == null ||
        conversation.conversationId!.trim().isEmpty) {
      return false;
    }
    switch (dbBox) {
      case IsmChatDbBox.main:
        await chatConversationBox.put(
                conversation.conversationId ?? '', conversation.toMap())
            as Map<String, dynamic>?;
        break;
      case IsmChatDbBox.pending:
        await pendingMessageBox.put(
            conversation.conversationId ?? '',
            conversation.messages?.isEmpty == true
                ? []
                : conversation.messages!.map((e) => e.toMap()).toList());
        break;
      case IsmChatDbBox.forward:
        await forwardMessageBox.put(
            conversation.conversationId ?? '',
            conversation.messages?.isEmpty == true
                ? []
                : conversation.messages!.map((e) => e.toMap()).toList());
        break;
    }
    return true;
  }

  Future<List<IsmChatMessageModel>?> getMessage(String conversationId,
      [IsmChatDbBox dbBox = IsmChatDbBox.main]) async {
    if (conversationId.isEmpty) {
      return null;
    }
    List<IsmChatMessageModel>? messgges;
    switch (dbBox) {
      case IsmChatDbBox.main:
        var mainConversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (mainConversation != null) {
          messgges = mainConversation.messages;
        }
        break;
      case IsmChatDbBox.pending:
        var pendingConversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (pendingConversation != null) {
          messgges = pendingConversation.messages;
        }
        break;
      case IsmChatDbBox.forward:
        var forwardConversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (forwardConversation != null) {
          messgges = forwardConversation.messages;
        }
        break;
    }
    return messgges;
  }

  Future<void> saveMessage(
    IsmChatMessageModel message, [
    IsmChatDbBox dbBox = IsmChatDbBox.main,
  ]) async {
    if ((message.messageId == null && message.conversationId == null) ||
        (message.messageId!.trim().isEmpty &&
            message.conversationId!.trim().isEmpty)) {
      return;
    }
    switch (dbBox) {
      case IsmChatDbBox.main:
        var conversation = await getConversation(
            conversationId: message.conversationId, dbBox: dbBox);
        if (conversation == null) {
          conversation?.copyWith(
              conversationId: message.conversationId, messages: [message]);
          await saveConversation(conversation: conversation!, dbBox: dbBox);
          return;
        }
        conversation.messages?.add(message);
        await saveConversation(conversation: conversation, dbBox: dbBox);
        break;
      case IsmChatDbBox.pending:
        var conversation = await getConversation(
            conversationId: message.conversationId, dbBox: dbBox);
        if (conversation == null) {
          conversation?.copyWith(
              conversationId: message.conversationId, messages: [message]);
          await saveConversation(conversation: conversation!, dbBox: dbBox);
          return;
        }
        conversation.messages?.add(message);
        await saveConversation(conversation: conversation, dbBox: dbBox);
        break;
      case IsmChatDbBox.forward:
        var conversation = await getConversation(
            conversationId: message.conversationId, dbBox: dbBox);
        if (conversation == null) {
          conversation?.copyWith(
              conversationId: message.conversationId, messages: [message]);
          await saveConversation(conversation: conversation!, dbBox: dbBox);
          return;
        }
        conversation.messages?.add(message.toMap() as IsmChatMessageModel);
        await saveConversation(conversation: conversation, dbBox: dbBox);
        break;
    }
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
        var conversation = await getConversation(
            conversationId: conversationModel.conversationId);
        if (conversation == null) {
          await saveConversation(conversation: conversation!);
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
        await saveConversation(conversation: conversation);
      }
    } catch (e, st) {
      IsmChatLog.error('$e \n$st');
    }
  }

  // /// Add pending Message
  // Future<void> addPendingMessage(IsmChatMessageModel messageModel) async {
  //   final chatPendingMessages =
  //       await getConversation(messageModel.conversationId);
  //   if (chatPendingMessages != null) {
  //     chatPendingMessages.messages?.add(messageModel);
  //     await pendingMessageBox.put(
  //         chatPendingMessages.conversationId!, chatPendingMessages.toMap());
  //   } else {
  //     var pendingMessageModel = IsmChatConversationModel(
  //       conversationId: messageModel.conversationId ?? '',
  //       messages: [messageModel],
  //     );
  //     await pendingMessageBox.put(pendingMessageModel.conversationId ?? '',
  //         pendingMessageModel.toMap());
  //   }
  // }

  // /// Add forward Message
  // Future<void> addForwardMessage(IsmChatMessageModel messageModel) async {
  //   final chatForwardMessages =
  //       await getConversation(messageModel.conversationId);
  //   if (chatForwardMessages != null) {
  //     chatForwardMessages.messages?.add(messageModel);
  //     await forwardMessageBox.put(chatForwardMessages.conversationId ?? '',
  //         chatForwardMessages.toMap());
  //   } else {
  //     var forwardMessageModel = IsmChatConversationModel(
  //         conversationId: messageModel.conversationId ?? '',
  //         messages: [messageModel]);
  //     await forwardMessageBox.put(forwardMessageModel.conversationId ?? '',
  //         forwardMessageModel.toMap());
  //   }
  // }

  // Future<List<IsmChatMessageModel>?> getMessages(String? conversationId) async {
  //   if (conversationId == null) {
  //     return null;
  //   }
  //   var messages = <String>[];
  //   var conversationForPending = pendingMessageBox
  //       .query(PendingMessageModel_.conversationId.equals(conversationId))
  //       .build()
  //       .findUnique();
  //   if (conversationForPending != null) {
  //     messages.addAll(conversationForPending.messages);
  //   }
  //   var conversationForForward = forwardMessageBox
  //       .query(ForwardMessageModel_.conversationId.equals(conversationId))
  //       .build()
  //       .findUnique();
  //   if (conversationForForward != null) {
  //     messages.addAll(conversationForForward.messages);
  //   }
  //   var conversation = chatConversationBox
  //       .query(DBConversationModel_.conversationId.equals(conversationId))
  //       .build()
  //       .findUnique();
  //   if (conversation == null) {
  //     return null;
  //   } else {
  //     messages.addAll(conversation.messages);
  //   }
  //   return messages.map(IsmChatMessageModel.fromJson).toList();
  // }

  // Future<DBConversationModel?> getDBConversation(
  //     {required String conversationId}) async {
  //   var conversation = chatConversationBox
  //       .query(DBConversationModel_.conversationId.equals(conversationId))
  //       .build()
  //       .findUnique();
  //   if (conversation == null) {
  //     return null;
  //   }
  //   return conversation;
  // }

  // Future<void> saveMessages(
  //   String conversationId,
  //   List<IsmChatMessageModel> messages,
  // ) async {
  //   var conversation = chatConversationBox
  //       .query(DBConversationModel_.conversationId.equals(conversationId))
  //       .build()
  //       .findUnique();
  //   if (conversation != null) {
  //     conversation.messages =
  //         messages.isEmpty ? [] : messages.map((e) => e.toJson()).toList();

  //     if (messages.isEmpty) {
  //       conversation.lastMessageDetails.target =
  //           conversation.lastMessageDetails.target!.copyWith(
  //         sentByMe: conversation.lastMessageDetails.target!.sentByMe,
  //         showInConversation:
  //             conversation.lastMessageDetails.target!.showInConversation,
  //         sentAt: DateTime.now().millisecondsSinceEpoch,
  //         senderName: conversation.lastMessageDetails.target!.senderName,
  //         messageType: 0,
  //         messageId: '',
  //         conversationId: conversationId,
  //         customType: conversation.lastMessageDetails.target!.customType,
  //         body: '',
  //       );
  //     }
  //     await chatConversationBox.put(conversation);
  //     if (messages.isEmpty) {
  //       var conversationForPendingMessge = pendingMessageBox
  //           .query(PendingMessageModel_.conversationId.equals(conversationId))
  //           .build()
  //           .findUnique();
  //       if (conversationForPendingMessge != null) {
  //         pendingMessageBox.remove(conversationForPendingMessge.id);
  //       }
  //       var conversationForForwardMessge = forwardMessageBox
  //           .query(ForwardMessageModel_.conversationId.equals(conversationId))
  //           .build()
  //           .findUnique();
  //       if (conversationForForwardMessge != null) {
  //         forwardMessageBox.remove(conversationForForwardMessge.id);
  //       }
  //     }
  //   }
  // }

  Future<void> removePendingMessage(
    String conversationId,
    List<IsmChatMessageModel> messages, [
    IsmChatDbBox dbBox = IsmChatDbBox.pending,
  ]) async {
    if (dbBox == IsmChatDbBox.pending) {
      var pendingMessge = await getConversation(
        conversationId: conversationId,
        dbBox: dbBox,
      );

      if (pendingMessge != null) {
        var pendingMessages = pendingMessge.messages!;
        for (var x in messages) {
          pendingMessages.removeWhere((e) => e.sentAt == x.sentAt);
        }
        var conversation = IsmChatConversationModel(
            conversationId: conversationId, messages: pendingMessages);
        await saveConversation(conversation: conversation, dbBox: dbBox);
      }
    } else {
      var forwardMessge = await getConversation(
        conversationId: conversationId,
        dbBox: dbBox,
      );
      if (forwardMessge != null) {
        var forwardMessages = forwardMessge.messages!;
        for (var x in messages) {
          forwardMessages.removeWhere((e) => e.sentAt == x.sentAt);
        }
        var conversation = IsmChatConversationModel(
            conversationId: conversationId, messages: forwardMessages);
        await saveConversation(conversation: conversation, dbBox: dbBox);
      }
    }
  }

  Future<void> removeConversation(String conversationId,
      [IsmChatDbBox dbBox = IsmChatDbBox.main]) async {
    switch (dbBox) {
      case IsmChatDbBox.main:
        var conversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (conversation != null) {
          await chatConversationBox.delete(conversationId);
        }
        break;
      case IsmChatDbBox.pending:
        var pendingConversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (pendingConversation != null) {
          await chatConversationBox.delete(conversationId);
        }
        break;
      case IsmChatDbBox.forward:
        var forwardConversation =
            await getConversation(conversationId: conversationId, dbBox: dbBox);
        if (forwardConversation != null) {
          await chatConversationBox.delete(conversationId);
        }
        break;
    }
  }
}
