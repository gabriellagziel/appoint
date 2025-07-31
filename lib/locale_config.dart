import 'package:flutter/material.dart';

class LocaleConfig {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('es', 'ES'), // Spanish
    Locale('fr', 'FR'), // French
    Locale('de', 'DE'), // German
    Locale('it', 'IT'), // Italian
    Locale('pt', 'PT'), // Portuguese
    Locale('ru', 'RU'), // Russian
    Locale('zh', 'CN'), // Chinese
    Locale('ja', 'JP'), // Japanese
    Locale('ko', 'KR'), // Korean
    Locale('ar', 'SA'), // Arabic
    Locale('hi', 'IN'), // Hindi
  ];
  
  static const Locale fallbackLocale = Locale('en', 'US');
  
  static Locale getLocaleFromUrl(String? langCode) {
    if (langCode == null) return fallbackLocale;
    
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == langCode,
      orElse: () => fallbackLocale,
    );
  }
}
