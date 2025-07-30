const Map<String, String> countries = {
  'US': 'United States',
  'IL': 'Israel',
  'GB': 'United Kingdom',
  'DE': 'Germany',
  'FR': 'France',
};

String getCountryName(String code) =>
    countries[code.toUpperCase()] ?? 'Unknown';
