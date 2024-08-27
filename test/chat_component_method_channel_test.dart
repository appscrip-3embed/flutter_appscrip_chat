// ignore_for_file: deprecated_member_use

import 'package:appscrip_chat_component/appscrip_chat_component_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var platform = MethodChannelChatComponent();
  const channel = MethodChannel('appscrip_chat_component');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(
    () =>
        channel.setMockMethodCallHandler((MethodCall methodCall) async => '42'),
  );

  tearDown(() => channel.setMockMethodCallHandler(null));

  test('getPlatformVersion',
      () async => expect(await platform.getPlatformVersion(), '42'));
}
