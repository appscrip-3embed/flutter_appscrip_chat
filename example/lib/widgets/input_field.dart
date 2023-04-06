import 'package:chat_component_example/res/dimens.dart';
import 'package:chat_component_example/res/res.dart';
import 'package:chat_component_example/utilities/validator.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.onchange,
    String? Function(String?)? validator,
    TextInputType? textInputType,
  })  : _validator = validator,
        _textInputType = textInputType ?? TextInputType.text;

  const InputField.userName({
    super.key,
    required this.controller,
    this.onchange,
    String? Function(String?)? validator,
  })  : _textInputType = TextInputType.name,
        _validator = validator ?? AppValidator.userName;

  const InputField.email({
    super.key,
    required this.controller,
    this.onchange,
    String? Function(String?)? validator,
  })  : _textInputType = TextInputType.emailAddress,
        _validator = validator ?? AppValidator.emailValidator;

  const InputField.password({
    super.key,
    required this.controller,
    this.onchange,
    String? Function(String?)? validator,
  })  : _textInputType = TextInputType.visiblePassword,
        _validator = validator ?? AppValidator.passwordValidator;

  const InputField.confirmPassword({
    super.key,
    required this.controller,
    this.onchange,
    String? Function(String?)? validator,
  })  : _textInputType = TextInputType.visiblePassword,
        _validator = validator ?? AppValidator.passwordValidator;

  final TextEditingController controller;

  final String? Function(String?)? _validator;
  final TextInputType _textInputType;
  final Function(String value)? onchange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.sixTeen),
          borderSide: const BorderSide(
            color: AppColors.primaryColorDark,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.sixTeen),
          borderSide: const BorderSide(
            color: AppColors.primaryColorDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.sixTeen),
          borderSide: const BorderSide(
            color: AppColors.primaryColorLight,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.sixTeen),
          borderSide: const BorderSide(
            color: AppColors.errorColor,
            width: 1,
          ),
        ),
        counterText: '',
      ),
      validator: _validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: _textInputType,
      onChanged: onchange,
    );
  }
}
