import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IsmChatTextMessage extends StatelessWidget {
  const IsmChatTextMessage(this.message, {super.key});

  final IsmChatMessageModel message;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Container(
          alignment:
              message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          constraints: const BoxConstraints(
            minHeight: 36,
          ),
          padding: IsmChatDimens.edgeInsets4,
          child: RichText(
            text: TextSpan(
              text: message.mentionedUsers.isNullOrEmpty ? message.body : null,
              style: message.style,
              children: message.mentionedUsers.isNullOrEmpty
                  ? null
                  : message.mentionList
                      .map(
                        (e) => TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = !e.isMentioned
                                ? null
                                : () async {
                                    var user = message.mentionedUsers
                                        ?.where((user) =>
                                            user.userName.toLowerCase() ==
                                            e.text.substring(1).toLowerCase())
                                        .toList();

                                    if (!user.isNullOrEmpty) {
                                      var conversationcontroller = Get.find<
                                          IsmChatConversationsController>();
                                      var conversationId =
                                          conversationcontroller
                                              .getConversationId(
                                                  user!.first.userId);
                                      conversationcontroller.contactDetails =
                                          user.first;
                                      conversationcontroller
                                          .userConversationId = conversationId;
                                      if (Responsive.isWebAndTablet(context)) {
                                        conversationcontroller
                                                .isRenderChatPageaScreen =
                                            IsRenderChatPageScreen.userInfoView;
                                      } else {
                                        IsmChatRouteManagement.goToUserInfo(
                                          conversationId: conversationId,
                                          user: user.first,
                                        );
                                      }
                                    }
                                  },
                          text: e.text,
                          style: (message.style).copyWith(
                            color: e.isMentioned
                                ? message.sentByMe
                                    ? IsmChatConfig.chatTheme.mentionColor
                                    : IsmChatConfig.chatTheme.primaryColor
                                : null,
                          ),
                        ),
                      )
                      .toList(),
            ),
            softWrap: true,
            maxLines: null,
          ),
        ),
      );
}
