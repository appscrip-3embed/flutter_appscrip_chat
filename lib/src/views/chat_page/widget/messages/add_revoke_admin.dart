import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatAddRevokeAdmin extends StatelessWidget {
  const IsmChatAddRevokeAdmin(
    this.message, {
    this.isAdded = true,
    super.key,
  });

  final IsmChatMessageModel message;
  final bool isAdded;

  // String get _user =>
  //     message.memberId == IsmChatConfig.communicationConfig.userConfig.userId
  //         ? 'you'
  //         : message.memberName!;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: IsmChatConfig.chatTheme.backgroundColor,
          borderRadius: BorderRadius.circular(IsmChatDimens.eight),
        ),
        padding: IsmChatDimens.edgeInsets8_4,
        child: Text(
          '${message.initiator} ${isAdded ? 'added' : 'removed'} you as an Admin'
              .trim(), //'${message.initiator} ${isAdded ? 'added' : 'removed'} $_user ${isAdded ? 'as' : 'as an '} Admin'.trim()
          textAlign: TextAlign.center,
          style: IsmChatStyles.w500Black12.copyWith(
            color: message.centerMessageColor,
          ),
        ),
      );
}
