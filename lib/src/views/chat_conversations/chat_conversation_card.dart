import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatConversationCard extends StatelessWidget {
  const IsmChatConversationCard(
    this.conversation, {
    this.profileImageBuilder,
    this.nameBuilder,
    this.subtitleBuilder,
    this.onTap,
    this.onProfileWidget,
    super.key,
  });

  final IsmChatConversationModel conversation;
  final VoidCallback? onTap;
  final Widget? onProfileWidget;
  final Widget? Function(BuildContext, String)? profileImageBuilder;
  final Widget? Function(BuildContext, String)? nameBuilder;
  final Widget? Function(BuildContext, String)? subtitleBuilder;

  @override
  Widget build(BuildContext context) => IsmChatTapHandler(
        onTap: onTap,
        child: SizedBox(
          child: ListTile(
            dense: true,
            leading:
                Stack(
                  children: [
                    profileImageBuilder?.call(context, conversation.profileUrl) ??
                        IsmChatImage.profile(
                          conversation.profileUrl,
                          name: conversation.chatName,
                        ),
                     Positioned(
                        top: IsmChatDimens.twentyFour,
                        child: onProfileWidget == null ? IsmChatDimens.box0 : conversation.metaData?.isMatchId?.isNotEmpty == true ? onProfileWidget! :IsmChatDimens.box0,
                      )   
                  ],
                ),
            title: nameBuilder?.call(context, conversation.chatName) ??
                Text(
                  conversation.chatName,
                  style: IsmChatStyles.w600Black14,
                ),
            subtitle: subtitleBuilder?.call(
                    context, conversation.lastMessageDetails?.body ?? '') ??
                conversation.lastMessageDetails!.body.lastMessageType(conversation.lastMessageDetails!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation.lastMessageDetails!.sentAt
                      .toLastMessageTimeString(),
                  style: IsmChatStyles.w400Black10,
                ),
                if (conversation.unreadMessagesCount != null &&
                    conversation.unreadMessagesCount != 0)
                  Container(
                    height: IsmChatDimens.twenty,
                    width: IsmChatDimens.twenty,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: IsmChatConfig.chatTheme.primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      conversation.unreadMessagesCount.toString(),
                      style: IsmChatStyles.w700White10,
                    ),
                  )
              ],
            ),
          ),
        ),
      );
}
