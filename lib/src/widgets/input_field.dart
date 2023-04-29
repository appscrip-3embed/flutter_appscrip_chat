import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatInputField extends StatelessWidget {
  const IsmChatInputField({
    this.controller,
    this.padding,
    this.suffixIcon,
    this.hint,
    this.onChanged,
    super.key,
  });

  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? hint;
  final EdgeInsets? padding;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? IsmChatDimens.edgeInsets10_4,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: IsmChatStyles.w400Grey12,
            contentPadding: IsmChatDimens.edgeInsets10,
            isDense: true,
            isCollapsed: true,
            filled: true,
            fillColor: IsmChatConfig.chatTheme.backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(IsmChatDimens.ten),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(IsmChatDimens.ten),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            suffixIcon: suffixIcon,
          ),
          onChanged: onChanged,
        ),
      );
}
