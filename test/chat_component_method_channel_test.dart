import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_component/chat_component_method_channel.dart';

void main() {
  MethodChannelChatComponent platform = MethodChannelChatComponent();
  const MethodChannel channel = MethodChannel('chat_component');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
