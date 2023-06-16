import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
// import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

/// Provides access to the ObjectBox Store throughout the presenter.
///
/// Create this in the apps main function.

class DBWrapper {
  DBWrapper._create(this.collection);

  /// The Store of this presenter.
  late final BoxCollection collection;

  static const String _userBox = 'userData';

  /// A Box of user Details.
  late final CollectionBox<String> userDetailsBox;

  Future<void> _createBox() async {
    var data = await collection.openBox<String>(_userBox);
    var boxes = data;
    userDetailsBox = boxes;
  }

  /// Create an instance of ObjectBox to use throughout the presenter.
  static Future<DBWrapper> create([String? databaseName]) async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart.

    var dbName = databaseName ?? IsmChatConfig.dbName;
    var directory = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      dbName,
      {
        _userBox,
      },
      path: directory.path,
    );

    var instance = DBWrapper._create(collection);
    await instance._createBox();
    return instance;
  }

  /// delete chat object box
  Future<void> deleteChatLocalDb() async {
    await userDetailsBox.clear();
    IsmChatLog.success('[CLEARED] - All entries are removed from database');
  }
}
