import 'dart:ui';

import 'package:chat_component/chat_component.dart';
import 'package:chat_component_example/res/strings.dart';

class AppTranslations extends ChatTranslations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          TranslationKeys.login: 'Login',
          TranslationKeys.register: 'Register',
          TranslationKeys.required: '*Required',
          TranslationKeys.email: 'Email',
          TranslationKeys.password: 'Password',
          TranslationKeys.invalid: 'Invalid',
          TranslationKeys.number: 'Number (0-9)',
          TranslationKeys.lowercase: 'Lowercase alphabets (a-z)',
          TranslationKeys.uppercase: 'Uppercase alphabets (A-Z)',
          TranslationKeys.symbol: 'Special symbols (@,\$,! etc)',
          TranslationKeys.mustContain: 'Password must contain @character',
        },
      };

  @override
  List<Locale> get locales => [const Locale('en')];
}
