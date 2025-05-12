import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class NoiseBuilder extends StatelessWidget {
  const NoiseBuilder({
    super.key,
    required this.widget,
    required this.audioConfigurationDone,
    required AnimationController? animationController,
    required this.noise,
  }) : _animationController = animationController;

  final VoiceMessage widget;
  final bool audioConfigurationDone;
  final AnimationController? _animationController;
  final Widget noise;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: IsmChatDimens.hundred,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            noise,
            if (audioConfigurationDone)
              AnimatedBuilder(
                animation: CurvedAnimation(
                    parent: _animationController!, curve: Curves.ease),
                builder: (context, child) => Positioned(
                  left: _animationController?.value ?? 0,
                  child: Container(
                    height: IsmChatDimens.eighty,
                    width: 120,
                    color: widget.me
                        ? widget.meBgColor.applyIsmOpacity(.4)
                        : widget.contactBgColor.applyIsmOpacity(.35),
                  ),
                ),
              ),
          ],
        ),
      );
}
