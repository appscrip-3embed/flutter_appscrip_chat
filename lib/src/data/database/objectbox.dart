import 'dart:io';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/app/chat_constant.dart';
import 'package:appscrip_chat_component/src/data/database/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.
class ChatObjectBox {
  ChatObjectBox._create(this.store) {
    userDetailsBox = Box<UserDetails>(store);
  }

  static late final String _dbPath;

  /// The Store of this presenter.
  late final Store store;

  /// A Box of user Details.
  late final Box<UserDetails> userDetailsBox;

  // static Query<UserMessage> query = noteBox.query(UserMessage_.conversationId.equals())

  static Future<ChatObjectBox> _openStore() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    final store = await openStore(directory: _dbPath);
    ChatLog.success('[CREATED] - Objectbox databse at $_dbPath');
    return ChatObjectBox._create(store);
  }

  /// Create an instance of ObjectBox to use throughout the presenter.
  static Future<ChatObjectBox> create([String? databaseName]) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    try {
      var dbName = databaseName ?? ChatConstants.dbName;
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
