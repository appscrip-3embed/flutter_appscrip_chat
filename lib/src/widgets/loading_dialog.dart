import 'package:appscrip_chat_component/src/res/res.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: Card(
            color: ChatTheme.of(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: ChatTheme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      );
}
