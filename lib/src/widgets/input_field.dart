import 'package:appscrip_chat_component/appscrip_chat_component.dart';
import 'package:flutter/material.dart';

class IsmChatInputField extends StatelessWidget {
  const IsmChatInputField({
    this.controller,
    this.padding,
    this.suffixIcon,
    this.hint,
    this.onChanged,
    this.fillColor,
    this.cursorColor,
    this.textInputAction,
    this.style,
    this.autofocus,
    this.hintStyle,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? hint;
  final EdgeInsets? padding;
  final Function(String)? onChanged;
  final Color? fillColor;
  final Color? cursorColor;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? autofocus;
  final  Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? IsmChatDimens.edgeInsets10_4,
        child: TextFormField(
          cursorColor: cursorColor ?? IsmChatColors.whiteColor,
          controller: controller,
          textInputAction: textInputAction ?? TextInputAction.search,
          autofocus: autofocus ?? true,
          style: style ?? IsmChatStyles.w500White16,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: hintStyle ?? IsmChatStyles.w400Grey12,
            contentPadding: IsmChatDimens.edgeInsets10,
            isDense: true,
            isCollapsed: true,
            filled: true,
            fillColor: fillColor ?? IsmChatConfig.chatTheme.backgroundColor,
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
          onFieldSubmitted: onFieldSubmitted,
        ),
      );
}
