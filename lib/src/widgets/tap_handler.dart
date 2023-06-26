import 'package:flutter/material.dart';

class IsmChatTapHandler extends StatelessWidget {
  const IsmChatTapHandler({
    super.key,
    this.onTap,
    this.onLongPress,
    this.behavior,
    required this.child,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HitTestBehavior? behavior;
  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: behavior ?? HitTestBehavior.translucent,
        child: child,
      );
}
