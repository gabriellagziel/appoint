const Map<String, String> countries = {
  'US': 'United States',
  'IL': 'Israel',
  'GB': 'United Kingdom',
  'DE': 'Germany',
  'FR': 'France',
};

String getCountryName(final String code) {
  return countries[code.toUpperCase()] ?? 'Unknown';
}
