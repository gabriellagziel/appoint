import 'dart:convert';

import 'package:appoint/features/studio_business/models/business_availability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final REDACTED_TOKEN =
    Provider<BusinessAvailabilityService>((ref) => BusinessAvailabilityService());

class BusinessAvailabilityService {
  static const String _storageKey = 'business_availability_config';

  /// Save the business availability configuration to local storage
  Future<void> saveConfiguration(Map<String, dynamic> config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(config));
  }

  /// Load the business availability configuration from local storage
  Future<List<BusinessAvailability>> loadConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final configString = prefs.getString(_storageKey);

    if (configString == null) {
      // Return default configuration if no saved config exists
      return [
        for (int i = 0; i < 7; i++)
          BusinessAvailability(
            weekday: i,
            isOpen: i != 0, // Sunday (0) is closed by default
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 17, minute: 0),
          ),
      ];
    }

    try {
      final config = jsonDecode(configString) as Map<String, dynamic>;
      final availabilityList = config['availability'] as List<dynamic>;

      return availabilityList
          .map((item) =>
              BusinessAvailability.fromJson(item as Map<String, dynamic>),)
          .toList();
    } catch (e) {
      // Return default configuration if parsing fails
      return [
        for (int i = 0; i < 7; i++)
          BusinessAvailability(
            weekday: i,
            isOpen: i != 0,
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 17, minute: 0),
          ),
      ];
    }
  }

  /// Update a specific day's availability
  Future<void> updateDay(
      int weekday, final BusinessAvailability availability,) async {
    final currentConfig = await loadConfiguration();
    final updatedConfig = currentConfig.map((final day) {
      if (day.weekday == weekday) {
        return availability;
      }
      return day;
    }).toList();

    await saveConfiguration(toJson(updatedConfig));
  }

  /// Convert a list of BusinessAvailability to a JSON map for saving
  Map<String, dynamic> toJson(List<BusinessAvailability> availability) => {
      'availability': availability.map((a) => a.toJson()).toList(),
    };
}
