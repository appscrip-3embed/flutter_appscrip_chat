import 'dart:io';

import 'package:chat_component_example/models/models.dart';
import 'package:chat_component_example/res/strings.dart';
import 'package:chat_component_example/utilities/app_log.dart';
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';

// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.
class ObjectBox {
  ObjectBox._create(this.store) {
    userDetailsBox = Box<UserDetailsModel>(store);
  }

  static late final String _dbPath;

  /// The Store of this presenter.
  late final Store store;

  /// A Box of user Details.
  late final Box<UserDetailsModel> userDetailsBox;

  // static Query<UserMessage> query = noteBox.query(UserMessage_.conversationId.equals())

  static Future<ObjectBox> _openStore() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    final store = await openStore(directory: _dbPath);
    return ObjectBox._create(store);
  }

  /// delete object box
  void deleteLocalDb() async {
    userDetailsBox.removeAll();
    AppLog.success('[CLEARED] - All entries are removed from database');
  }

  /// Create an instance of ObjectBox to use throughout the presenter.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.
    try {
      var docDir = await getApplicationDocumentsDirectory();
      _dbPath = '${docDir.path}/${Strings.name}';
      return await _openStore();
    } on ObjectBoxException catch (e) {
      AppLog.error('[ObjectBox create] - Error : $e');
      var directory = Directory(_dbPath);
      await directory.delete(recursive: true);
      AppLog.info('[DELETED] - Database');
      return await _openStore();
    }
  }
}
