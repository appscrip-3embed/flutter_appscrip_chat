import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chat_component_platform_interface.dart';

/// An implementation of [ChatComponentPlatform] that uses method channels.
class MethodChannelChatComponent extends ChatComponentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('chat_component');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
