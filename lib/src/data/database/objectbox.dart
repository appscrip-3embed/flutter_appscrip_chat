// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:objectbox_with_chat/ism_model/ism_model.dart';
// import 'package:objectbox_with_chat/ism_utils/manager/db_manager/objectbox.g.dart';
// import 'package:path_provider/path_provider.dart';

// // import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

// /// Provides access to the ObjectBox Store throughout the presenter.
// ///
// /// Create this in the apps main function.
// class ObjectBox {
//   ObjectBox._create(this.store) {
//     userMessageBox = Box<UserMessage>(store);
//     pendingMessageBox = Box<PendingMessage>(store);
//     forwardMessageBox = Box<ForwardMessage>(store);
//   }

//   static late final String _dbPath;

//   /// The Store of this presenter.
//   late final Store store;

//   /// A Box of user Message.
//   late final Box<UserMessage> userMessageBox;

//   /// A Box of pending Messages.
//   late final Box<PendingMessage> pendingMessageBox;

//   /// A Box of forward Messages.
//   late final Box<ForwardMessage> forwardMessageBox;

//   // static Query<UserMessage> query = noteBox.query(UserMessage_.conversationId.equals())

//   static Future<ObjectBox> _openStore() async {
//     // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
//     final store = await openStore(directory: _dbPath);
//     return ObjectBox._create(store);
//   }

//   /// Create an instance of ObjectBox to use throughout the presenter.
//   static Future<ObjectBox> create() async {
//     // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
//     try {
//       var docDir = await getApplicationDocumentsDirectory();
//       _dbPath = '${docDir.path}/testDB';
//       return await _openStore();
//     } on ObjectBoxException catch (e) {
//       log('[ObjectBox create] - Error : $e');
//       var directory = Directory(_dbPath);
//       await directory.delete(recursive: true);
//       log('[DELETED] - Database');
//       return await _openStore();
//     }
//     // final store = await openStore();
//     // return ObjectBox._create(store);
//   }

//   /// Add a note within a transaction.
//   ///
//   /// To avoid frame drops, run ObjectBox operations that take longer than a
//   /// few milliseconds, e.g. putting many objects, in an isolate with its
//   /// own Store instance.
//   /// For this example only a single object is put which would also be fine if
//   /// done here directly.
//   Future<void> addNote(types.MessageData message) =>
//       store.runInTransactionAsync(
//         TxMode.write,
//         _addNoteInTx,
//         message,
//       );

//   /// call function for Add pending messages in DB
//   Future<void> addPendingMessage(
//       types.MessageData message, String conversationId) async {
//     final allPendingMessage = store.box<PendingMessage>();
//     final query = allPendingMessage
//         .query(PendingMessage_.conversationId.equals(conversationId))
//         .build();
//     final chatPendingMessages = query.find(); // find() returns List
//     final messageInString = json.encode(message);
//     if (message.initiated! && chatPendingMessages.isNotEmpty) {
//       var index = allPendingMessage.get(chatPendingMessages.first.id);
//       index?.pendingMessages?.add(messageInString);
//       allPendingMessage.put(index!);
//     } else {
//       allPendingMessage.put(PendingMessage(
//           conversationId: conversationId, pendingMessages: [messageInString]));
//     }
//   }

//   /// call function for Add Forward messages in DB
//   Future<void> addForwadMessage(
//       types.MessageData message, String conversationId) async {
//     final allForwardMessage = store.box<ForwardMessage>();
//     final query = allForwardMessage
//         .query(ForwardMessage_.conversationId.equals(conversationId))
//         .build();
//     final chatForwardMessages = query.find(); // find() returns List
//     final messageInString = json.encode(message);
//     if (message.initiated! && chatForwardMessages.isNotEmpty) {
//       var index = allForwardMessage.get(chatForwardMessages.first.id);
//       index?.forwardMessage?.add(messageInString);
//       allForwardMessage.put(index!);
//     } else {
//       allForwardMessage.put(ForwardMessage(
//           conversationId: conversationId, forwardMessage: [messageInString]));
//     }
//   }

//   /// Note: due to [dart-lang/sdk#36983](https://github.com/dart-lang/sdk/issues/36983)
//   /// not using a closure as it may capture more objects than expected.
//   /// These might not be send-able to an isolate. See Store.runAsync for details.
//   static void _addNoteInTx(Store store, types.MessageData message) async {
//     final allConversations = store.box<UserMessage>().getAll();
//     final messageInString = json.encode(message);
//     var boxStore = store.box<UserMessage>();
//     if (message.initiated == null) {
//       return;
//     } else {
//       for (var x = 0; x < allConversations.length; x++) {
//         if (message.initiated!) {
//           if (message.receiverId == allConversations[x].receiverId) {
//             var index = boxStore.get(allConversations[x].id);
//             index?.mainMessageData?.insert(0, messageInString);
//             boxStore.put(index!);
//             break;
//           }
//         } else {
//           if (message.senderId == allConversations[x].receiverId) {
//             var index = boxStore.get(allConversations[x].id);
//             for (var y = 0; y < index!.mainMessageData!.length; y++) {
//               var stringToJson =
//                   dbMessageModelFromJson(index.mainMessageData![y]);
//               if (message.messageId == stringToJson.messageId) {
//                 return;
//               }
//             }
//             index.mainMessageData?.insert(0, messageInString);
//             boxStore.put(index);
//             break;
//           }
//         }
//       }
//     }
//   }
// }
