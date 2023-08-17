import 'package:flutter/material.dart';

class IsmChatTapHandler extends StatelessWidget {
  const IsmChatTapHandler({
    super.key,
    this.onTap,
    this.behavior,
    this.onLongPress,
    required this.child,
  });

  // const IsmChatTapHandler.withGesture({
  //   super.key,
  //   this.onTap,
  //   this.onLongPress,
  //   this.behavior,
  //   required this.child,
  // }) : _isGesture = true;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HitTestBehavior? behavior;
  final Widget child;
  // final bool _isGesture;

  @override
  Widget build(BuildContext context) {
    // if (_isGesture) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      hitTestBehavior: behavior ?? HitTestBehavior.translucent,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: behavior ?? HitTestBehavior.translucent,
        child: child,
      ),
    );
    // }
    // return InkWell(
    //   onTap: onTap,
    //   focusColor: Colors.transparent,
    //   hoverColor: Colors.transparent,
    //   splashColor: Colors.transparent,
    //   highlightColor: Colors.transparent,
    //   overlayColor: MaterialStateProperty.all(Colors.transparent),
    //   child: child,
    // );
  }
}
