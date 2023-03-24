import 'package:flutter/material.dart';

class IsmTapHandler extends StatelessWidget {
  const IsmTapHandler({super.key, this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor:
            MaterialStateProperty.resolveWith((states) => Colors.transparent),
        child: child,
      );
}