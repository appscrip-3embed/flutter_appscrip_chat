import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:appscrip_chat_component/src/res/properties/chat_properties.dart';
import 'package:flutter/material.dart';

class IsmChatLoadingDialog extends StatelessWidget {
  const IsmChatLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) => StatusBarTransparent(
        child: IsmChatProperties.loadingDialog ??
            Center(
              child: SizedBox(
                height: 60,
                width: 60,
                child: Card(
                  color: IsmChatTheme.of(context).backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: IsmChatConfig.chatTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
      );
}
