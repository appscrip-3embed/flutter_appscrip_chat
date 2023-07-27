import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class AvailabilityFloatingButton extends StatefulWidget {
  const AvailabilityFloatingButton({
    super.key,
    required this.onAddAvailability,
    required this.onAddEvent,
    required this.onRequestLeave,
  });

  final VoidCallback onAddAvailability;
  final VoidCallback onAddEvent;
  final VoidCallback onRequestLeave;

  @override
  State<AvailabilityFloatingButton> createState() =>
      _AvailabilityFloatingButtonState();
}

class _AvailabilityFloatingButtonState extends State<AvailabilityFloatingButton>
    with SingleTickerProviderStateMixin {
  // final controller = Get.find<AvailabilityController>();

  AnimationController? fabAnimationController;

  late Animation<double> _animation;
  late Animation<double> curve;
  late Animation<double> _buttonAnimation;
  bool isOpened = false;

  final children = ['Share', 'Icon', 'Buddon'];

  @override
  void initState() {
    super.initState();
    fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          isOpened = fabAnimationController?.isCompleted ?? false;
        });
      });
    curve = CurvedAnimation(
      parent: fabAnimationController!,
      curve: Curves.easeInOut,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _buttonAnimation = Tween<double>(
      begin: 10,
      end: 0,
    ).animate(curve);
  }

  @override
  void dispose() {
    fabAnimationController!.dispose();
    super.dispose();
  }

  void _toggle() {
    if (fabAnimationController!.isCompleted) {
      fabAnimationController!.reverse();
    } else {
      fabAnimationController!.forward();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...children.map((e) {
            var index = children.indexOf(e);
            return Transform(
              transform: Matrix4.translationValues(
                0.0,
                _buttonAnimation.value * (index + 1),
                0.0,
              ),
              child: Padding(
                padding: IsmChatDimens.edgeInsets0_4,
                child: IsmChatTapHandler(
                  onTap: () {
                    _toggle();
                    switch (index) {
                      case 0:
                        widget.onAddAvailability();
                        break;
                      case 1:
                        widget.onAddEvent();
                        break;
                      case 2:
                        widget.onRequestLeave();
                        break;
                    }
                  },
                  child: Opacity(
                    opacity: _animation.value,
                    child: Padding(
                      padding: IsmChatDimens.edgeInsets4,
                      child: Text(
                        e,
                        style: IsmChatStyles.w400Black14,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          // IsmChatDimens.boxHeight5,
          FloatingActionButton(
            backgroundColor: IsmChatConfig.chatTheme.primaryColor,
            onPressed: _toggle,
            child: AnimatedRotation(
              turns: _animation.value.clamp(0, 0.375),
              duration: const Duration(milliseconds: 1000),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
