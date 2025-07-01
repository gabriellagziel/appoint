import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/services/ambassador_quota_service.dart';
import 'fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('AmbassadorQuotaService Tests', () {
    late AmbassadorQuotaService service;

    setUp(() {
      service = AmbassadorQuotaService();
    });

    test('should return correct quota for valid country-language combination',
        () {
      expect(service.getQuota('US', 'en'), 345);
      expect(service.getQuota('CN', 'zh'), 400);
      expect(service.getQuota('IN', 'hi'), 200);
    });

    test('should return 0 for invalid country-language combination', () {
      expect(service.getQuota('XX', 'xx'), 0);
      expect(service.getQuota('US', 'xx'), 0);
      expect(service.getQuota('XX', 'en'), 0);
    });

    test('should have correct total global quota', () {
      final totalQuota = AmbassadorQuotaService.ambassadorQuotas.values
          .fold<int>(0, (final sum, final quota) => sum + quota);
      expect(totalQuota, equals(4787));
    });

    test('should include all major regions', () {
      const quotas = AmbassadorQuotaService.ambassadorQuotas;

      // Check for major countries
      expect(quotas.containsKey('US_en'), true);
      expect(quotas.containsKey('CN_zh'), true);
      expect(quotas.containsKey('IN_hi'), true);
      expect(quotas.containsKey('BR_pt'), true);
      expect(quotas.containsKey('NG_en'), true);

      // Check for major languages
      expect(quotas.values.any((final quota) => quota > 200),
          true); // Should have some large quotas
    });

    test('should have reasonable quota distribution', () {
      final quotas = AmbassadorQuotaService.ambassadorQuotas.values.toList();
      final averageQuota =
          quotas.fold<int>(0, (final sum, final quota) => sum + quota) / quotas.length;
      expect(averageQuota, greaterThan(95));
    });

    test('should handle edge cases in quota calculations', () {
      // Test with empty strings
      expect(service.getQuota('', ''), 0);
      expect(service.getQuota('US', ''), 0);
      expect(service.getQuota('', 'en'), 0);

      // Test with null-like values (empty strings)
      expect(service.getQuota('', 'en'), 0);
    });

    test('should have correct quota for specific countries', () {
      // Test some specific quotas from the requirements
      expect(service.getQuota('PL', 'pl'), 95);
      expect(service.getQuota('FR', 'fr'), 142);
      expect(service.getQuota('CA', 'en'), 54);
      expect(service.getQuota('CA', 'fr'), 46);
      expect(service.getQuota('IN', 'hi'), 200);
      expect(service.getQuota('IN', 'ta'), 84);
      expect(service.getQuota('IN', 'gu'), 63);
      expect(service.getQuota('US', 'en'), 345);
      expect(service.getQuota('ES', 'es'), 220);
      expect(service.getQuota('BR', 'pt'), 215);
    });

    test('should have exactly 50 country-language combinations', () {
      expect(AmbassadorQuotaService.ambassadorQuotas.length, 50);
    });

    test('should have no duplicate keys', () {
      final keys = AmbassadorQuotaService.ambassadorQuotas.keys.toList();
      final uniqueKeys = keys.toSet();
      expect(keys.length, uniqueKeys.length);
    });

    test('should have all quotas as positive integers', () {
      for (final quota in AmbassadorQuotaService.ambassadorQuotas.values) {
        expect(quota, isA<int>());
        expect(quota, greaterThan(0));
      }
    });

    test('should have correct key format (country_language)', () {
      for (final key in AmbassadorQuotaService.ambassadorQuotas.keys) {
        expect(key, matches(r'^[A-Z]{2}_[a-z]{2}$'));
      }
    });

    test('should match exact quota requirements from specification', () {
      // Test all the specific quotas mentioned in the requirements
      final expectedQuotas = {
        'PL_pl': 95,
        'FR_fr': 142,
        'CA_en': 54,
        'CA_fr': 46,
        'IN_hi': 200,
        'IN_ta': 84,
        'IN_gu': 63,
        'US_en': 345,
        'ES_es': 220,
        'BR_pt': 215,
        'RU_ru': 111,
        'DE_de': 133,
        'JP_ja': 116,
        'KR_ko': 98,
        'CN_zh': 400,
        'MX_es': 173,
        'IT_it': 144,
        'NG_en': 135,
        'NG_ha': 45,
        'PH_tl': 103,
        'PK_ur': 125,
        'BD_bn': 122,
        'VN_vi': 106,
        'TR_tr': 101,
        'IR_fa': 77,
        'RO_ro': 72,
        'UA_uk': 70,
        'GR_el': 66,
        'TH_th': 64,
        'ID_id': 88,
        'NL_nl': 61,
        'CZ_cs': 59,
        'HU_hu': 57,
        'BG_bg': 52,
        'HR_hr': 50,
        'SK_sk': 48,
        'LV_lv': 42,
        'LT_lt': 41,
        'RS_sr': 40,
        'MY_ms': 60,
        'FI_fi': 49,
        'SE_sv': 67,
        'NO_no': 44,
        'DK_da': 43,
        'ET_am': 56,
        'KE_sw': 53,
        'LK_si': 39,
        'NP_ne': 38,
        'ZA_zu': 36,
      };

      for (final entry in expectedQuotas.entries) {
        expect(AmbassadorQuotaService.ambassadorQuotas[entry.key], entry.value,
            reason: 'Quota mismatch for ${entry.key}');
      }
    });
  });
}
