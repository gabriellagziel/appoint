import 'package:appoint/services/ambassador_quota_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'firebase_test_helper.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('AmbassadorQuotaService Tests', () {
    test('should return correct quota for valid country-language combination',
        () {
      // Test static quota map directly
      expect(AmbassadorQuotaService.ambassadorQuotas['US_en'], 345);
      expect(AmbassadorQuotaService.ambassadorQuotas['CN_zh'], 400);
      expect(AmbassadorQuotaService.ambassadorQuotas['IN_hi'], 200);
    });

    test('should return 0 for invalid country-language combination', () {
      // Test static quota map directly
      expect(AmbassadorQuotaService.ambassadorQuotas['XX_xx'], null);
      expect(AmbassadorQuotaService.ambassadorQuotas['US_xx'], null);
      expect(AmbassadorQuotaService.ambassadorQuotas['XX_en'], null);
    });

    test('should have correct total global quota', () {
      final totalQuota = AmbassadorQuotaService.ambassadorQuotas.values
          .fold<int>(0, (sum, final quota) => sum + quota);
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
      expect(
        quotas.values.any((quota) => quota > 200),
        true,
      ); // Should have some large quotas
    });

    test('should have reasonable quota distribution', () {
      quotas = AmbassadorQuotaService.ambassadorQuotas.values.toList();
      final averageQuota =
          quotas.fold<int>(0, (sum, final quota) => sum + quota) /
              quotas.length;
      expect(averageQuota, greaterThan(95));
    });

    test('should handle edge cases in quota calculations', () {
      // Test with empty strings - these should return null, not 0
      expect(AmbassadorQuotaService.ambassadorQuotas[''], null);
      expect(AmbassadorQuotaService.ambassadorQuotas['US'], null);
      expect(AmbassadorQuotaService.ambassadorQuotas[''], null);

      // Test with null-like values (empty strings)
      expect(AmbassadorQuotaService.ambassadorQuotas[''], null);
    });

    test('should have correct quota for specific countries', () {
      // Test some specific quotas from the requirements
      expect(AmbassadorQuotaService.ambassadorQuotas['PL_pl'], 95);
      expect(AmbassadorQuotaService.ambassadorQuotas['FR_fr'], 142);
      expect(AmbassadorQuotaService.ambassadorQuotas['CA_en'], 54);
      expect(AmbassadorQuotaService.ambassadorQuotas['CA_fr'], 46);
      expect(AmbassadorQuotaService.ambassadorQuotas['IN_hi'], 200);
      expect(AmbassadorQuotaService.ambassadorQuotas['IN_ta'], 84);
      expect(AmbassadorQuotaService.ambassadorQuotas['IN_gu'], 63);
      expect(AmbassadorQuotaService.ambassadorQuotas['US_en'], 345);
      expect(AmbassadorQuotaService.ambassadorQuotas['ES_es'], 220);
      expect(AmbassadorQuotaService.ambassadorQuotas['BR_pt'], 215);
    });

    test('should have exactly 50 country-language combinations', () {
      expect(AmbassadorQuotaService.ambassadorQuotas.length, 50);
    });

    test('should have no duplicate keys', () {
      keys = AmbassadorQuotaService.ambassadorQuotas.keys.toList();
      uniqueKeys = keys.toSet();
      expect(keys.length, uniqueKeys.length);
    });

    test('should have all quotas as positive integers', () {
      for (quota in AmbassadorQuotaService.ambassadorQuotas.values) {
        expect(quota, isA<int>());
        expect(quota, greaterThan(0));
      }
    });

    test('should have correct key format (country_language)', () {
      for (key in AmbassadorQuotaService.ambassadorQuotas.keys) {
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

      for (entry in expectedQuotas.entries) {
        expect(
          AmbassadorQuotaService.ambassadorQuotas[entry.key],
          entry.value,
          reason: 'Quota mismatch for ${entry.key}',
        );
      }
    });
  });
}
