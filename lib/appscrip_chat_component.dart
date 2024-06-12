library appscrip_chat_component;

import 'dart:async';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/appscrip_chat_component_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  IsmChatCommunicationConfig? get config {
    assert(
      _initialized,
      'IsmChat is not initialized, initialize it using IsmChat.initialize(config)',
    );
    return _delegate.config;
  }

  Future<String?> getPlatformVersion() =>
      ChatComponentPlatform.instance.getPlatformVersion();

  Future<void> initialize(
    IsmChatCommunicationConfig communicationConfig, {
    bool useDatabase = true,
    String databaseName = IsmChatStrings.dbname,
    NotificaitonCallback? showNotification,
    BuildContext? context,
    bool isMqttInitializedFromOutSide = false,
  }) async {
    await _delegate.initialize(
      communicationConfig,
      useDatabase: useDatabase,
      showNotification: showNotification,
      context: context,
      databaseName: databaseName,
      isMqttInitializedFromOutSide: isMqttInitializedFromOutSide,
    );
    _initialized = true;
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
}
