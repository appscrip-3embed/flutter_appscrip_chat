import 'dart:ui';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatFocusMenu extends StatelessWidget {
  const IsmChatFocusMenu(
    this.message, {
    super.key,
    required this.animation,
    this.blur,
    this.blurBackgroundColor,
  });

  final double? blur;
  final Color? blurBackgroundColor;
  final IsmChatMessageModel message;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blur ?? 4,
                    sigmaY: blur ?? 4,
                  ),
                  child: Container(
                    color:
                        (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                  ),
                ),
              ),
              Padding(
                padding: IsmChatDimens.edgeInsets8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: message.sentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    FocusAnimationBuilder(
                      animation: animation,
                      axis: Axis.horizontal,
                      axisAlignment: 0,
                      child: ReactionGrid(message),
                    ),
                    IsmChatDimens.boxHeight8,
                    Hero(
                      tag: message,
                      child: MessageBubble(
                        message: message,
                        showMessageInCenter: false,
                      ),
                    ),
                    IsmChatDimens.boxHeight8,
                    FocusAnimationBuilder(
                      animation: animation,
                      axis: Axis.horizontal,
                      axisAlignment: 0,
                      child: ReactionGrid(message),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class FocusAnimationBuilder extends StatelessWidget {
  const FocusAnimationBuilder({
    required this.animation,
    required this.axis,
    required this.axisAlignment,
    required this.child,
    super.key,
  });

  final Axis axis;
  final double axisAlignment;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        builder: (context, widget) => ScaleTransition(
          scale: animation,
          child: widget!,
        ),
        child: child,
      );
}
