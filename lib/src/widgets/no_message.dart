import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class IsmChatNoMessage extends StatelessWidget {
  const IsmChatNoMessage({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: IsmChatDimens.edgeInsets16,
          child: const IsmIconAndText(
            icon: Icons.chat_outlined,
            text: IsmChatStrings.noMessages,
          ),
        ),
      );
}
