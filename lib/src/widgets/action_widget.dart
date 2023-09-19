import 'package:appscrip_chat_component/src/widgets/widgets.dart';
import 'package:flutter/material.dart';

class IsmChatActionWidget extends StatelessWidget {
  const IsmChatActionWidget({
    Key? key,
    required this.onTap,
    this.decoration,
    required this.icon,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  final VoidCallback onTap;
  final Decoration? decoration;
  final Widget icon;
  final String? label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: 1,
        child: IsmChatTapHandler(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: decoration,
            child: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  icon,
                  if (label != null && labelStyle != null)
                    Text(
                      label!,
                      style: labelStyle,
                    )
                ],
              ),
            ),
          ),
        ),
      );
}
