// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class IsmChatActionWidget extends StatelessWidget {
  const IsmChatActionWidget({
    Key? key,
    required this.onTap,
    required this.decoration,
    required this.icon,
    required this.label,
    required this.labelStyle,
  }) : super(key: key);

  final VoidCallback onTap;
  final Decoration decoration;
  final Widget icon;
  final String label;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: 1,
        child: IsmChatTapHandler(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: decoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Text(
                  label,
                  style: labelStyle,
                )
              ],
            ),
          ),
        ),
      );
}
