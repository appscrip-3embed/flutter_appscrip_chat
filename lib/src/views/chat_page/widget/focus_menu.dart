import 'dart:ui';

import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                        (blurBackgroundColor ?? Colors.black).withOpacity(0.5),
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
                    _FocusAnimationBuilder(
                      animation: animation,
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
                    _FocusAnimationBuilder(
                      animation: animation,
                      child: Container(
                        width: IsmChatDimens.oneHundredSeventy,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(IsmChatDimens.sixteen),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GetBuilder<IsmChatPageController>(
                            builder: (controller) => ListView.builder(
                                  itemCount: message.focusMenuList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    var item = message.focusMenuList[index];
                                    return IsmChatTapHandler(
                                      onTap: () {
                                        Get.back();
                                        controller.onMenuItemSelected(
                                          item,
                                          message,
                                        );
                                      },
                                      child: Container(
                                        height: IsmChatDimens.forty,
                                        padding: IsmChatDimens.edgeInsets16_0,
                                        decoration: BoxDecoration(
                                          color: item ==
                                                  IsmChatFocusMenuType.delete
                                              ? IsmChatColors.redColor
                                              : IsmChatConfig
                                                  .chatTheme.backgroundColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              item.toString(),
                                              style: IsmChatStyles.w400Black12
                                                  .copyWith(
                                                color: item ==
                                                        IsmChatFocusMenuType
                                                            .delete
                                                    ? IsmChatColors.whiteColor
                                                    : null,
                                              ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                              item.icon,
                                              color: item ==
                                                      IsmChatFocusMenuType
                                                          .delete
                                                  ? IsmChatColors.whiteColor
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _FocusAnimationBuilder extends StatelessWidget {
  const _FocusAnimationBuilder({
    required this.animation,
    required this.child,
  });

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
