import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String> _localizedStrings = {};

  Future<void> updateLanguage(String newLanguage) async {
    print(newLanguage);
    locale = Locale(newLanguage);
    await load();
  }

  Future<void> load() async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/translations/intl_${locale.languageCode}.arb');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      if (jsonMap.containsKey("@@locale") &&
          jsonMap["@@locale"] == locale.languageCode) {
        _localizedStrings = jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        });
      }
    } catch (error) {
      print('Error loading translations: $error');
    }
  }

  String? translate(String key) {
    return _localizedStrings.containsKey(key) ? _localizedStrings[key] : null;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
