import 'package:flutter_test/flutter_test.dart';
import 'package:chat_component/chat_component.dart';
import 'package:chat_component/chat_component_platform_interface.dart';
import 'package:chat_component/chat_component_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockChatComponentPlatform
    with MockPlatformInterfaceMixin
    implements ChatComponentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ChatComponentPlatform initialPlatform = ChatComponentPlatform.instance;

  test('$MethodChannelChatComponent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelChatComponent>());
  });

  test('getPlatformVersion', () async {
    ChatComponent chatComponentPlugin = ChatComponent();
    MockChatComponentPlatform fakePlatform = MockChatComponentPlatform();
    ChatComponentPlatform.instance = fakePlatform;

    expect(await chatComponentPlugin.getPlatformVersion(), '42');
  });
}
