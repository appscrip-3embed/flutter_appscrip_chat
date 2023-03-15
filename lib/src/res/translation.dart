import 'dart:ui';

import 'package:get/get.dart';

abstract class ChatTranslations extends Translations {
  ChatTranslations() {
    var missing = '';
    if (locales.length != keys.entries.length) {
      var mapKeys = keys.keys;
      if (locales.length > mapKeys.length) {
        var translation = locales
            .map((e) => e.languageCode)
            .where((l) => !mapKeys.contains(l))
            .join(', ');
        missing = 'Missing translation(s) are - $translation';
      } else {
        var missingLocales = mapKeys
            .where((l) => !locales.map((e) => e.languageCode).contains(l))
            .join(', ');
        missing = 'Extra translation(s) are - $missingLocales';
      }
    }
    assert(
      locales.length == keys.entries.length,
      'Translations should be set for all the locales. $missing',
    );
  }

  List<Locale> get locales;

  @override
  Map<String, Map<String, String>> get keys;
}
