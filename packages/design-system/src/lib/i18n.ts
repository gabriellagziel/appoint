// Simple i18n utility for fallback translations
export function t(key: string, fallback?: string): string {
  // For now, return the fallback or the key itself
  // This can be enhanced later with actual translation logic
  return fallback || key;
}

// Helper function to safely access nested translation keys
export function getTranslation(translations: any, key: string, fallback?: string): string {
  if (!translations) return fallback || key;
  
  const keys = key.split('.');
  let value = translations;
  
  for (const k of keys) {
    if (value && typeof value === 'object' && k in value) {
      value = value[k];
    } else {
      return fallback || key;
    }
  }
  
  return typeof value === 'string' ? value : (fallback || key);
}

// Export default translation function
export default t;
