import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class ChatTheme extends StatelessWidget {
  const ChatTheme({
    Key? key,
    required this.chatThemeData,
    required this.child,
  }) : super(key: key);

  final ChatThemeData chatThemeData;
  final Widget child;

  static final ChatThemeData _kFallbackTheme = ChatThemeData.fallback();

  static ChatThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_InheritedChatTheme>()
          ?.chatTheme
          .chatThemeData ??
      _kFallbackTheme;

  @override
  Widget build(BuildContext context) => _InheritedChatTheme(
        chatTheme: this,
        child: child,
      );
}

///
class _InheritedChatTheme extends InheritedTheme {
  const _InheritedChatTheme({
    required this.chatTheme,
    required super.child,
  });

  final ChatTheme chatTheme;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget.child != child;

  @override
  Widget wrap(BuildContext context, Widget child) => _InheritedChatTheme(
        chatTheme: chatTheme,
        child: child,
      );
}
