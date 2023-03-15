import 'package:get/get.dart';

class TranslationKeys {
  const TranslationKeys._();

  static const String login = 'login';
  static const String register = 'register';
  static const String required = 'required';
  static const String email = 'email';
  static const String password = 'password';
  static const String invalid = 'invalid';
  static const String mustContain = 'mustContain';
  static const String number = 'number';
  static const String lowercase = 'lowercase';
  static const String uppercase = 'uppercase';
  static const String symbol = 'symbol';
}

class Strings {
  const Strings._();

  static const String name = 'ChatApp';

  static String login = TranslationKeys.login.tr;
  static String register = TranslationKeys.register.tr;
  static String required = TranslationKeys.required.tr;
  static String email = TranslationKeys.email.tr;
  static String password = TranslationKeys.password.tr;
  static String invalid = TranslationKeys.invalid.tr;
  static String number = TranslationKeys.number.tr;
  static String lowercase = TranslationKeys.lowercase.tr;
  static String uppercase = TranslationKeys.uppercase.tr;
  static String symbol = TranslationKeys.symbol.tr;

  static String passwordMustContain(String character) =>
      TranslationKeys.mustContain.trParams({'character': character});
}
