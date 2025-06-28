const List<String> supportedLanguages = [
  'en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'ja', 'ko', 'zh',
  'ar', 'hi', 'bn', 'ur', 'fa', 'tr', 'nl', 'pl', 'sv', 'da',
  'no', 'fi', 'cs', 'sk', 'hu', 'ro', 'bg', 'hr', 'sl', 'et',
  'lv', 'lt', 'mt', 'ga', 'cy', 'eu', 'ca', 'gl', 'is', 'fo',
  'sq', 'mk', 'sr', 'bs'
];

bool isSupportedLanguage(String code) {
  return supportedLanguages.contains(code.toLowerCase());
}
