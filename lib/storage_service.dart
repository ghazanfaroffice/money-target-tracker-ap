import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'income_entry.dart';

// Ensure this path is correct based on your project structure

// This class is directly from your provided storage_service.dart
class StorageService {
  static const _targetKey = 'target_amount';
  static const _entriesKey = 'income_entries';

  Future<void> saveTarget(double target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_targetKey, target);
  }

  Future<double> getTarget() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_targetKey) ?? 0.0;
  }

  Future<void> saveEntries(List<IncomeEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_entriesKey, jsonEncode(jsonList));
  }

  Future<List<IncomeEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_entriesKey);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => IncomeEntry.fromJson(e)).toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_targetKey);
    await prefs.remove(_entriesKey);
  }
}
