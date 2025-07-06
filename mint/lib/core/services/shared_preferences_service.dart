import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys for different data types
  static const String _keyDailyQuote = 'daily_quote';
  static const String _keyQuoteAuthor = 'quote_author';
  static const String _keyQuoteDate = 'quote_date';
  static const String _keyIsFirstLaunch = 'is_first_launch';

  // Quote related methods
  Future<String?> getDailyQuote() async {
    return _preferences?.getString(_keyDailyQuote);
  }

  Future<bool> setDailyQuote(String quote) async {
    final result = await _preferences?.setString(_keyDailyQuote, quote);
    return result ?? false;
  }

  Future<String?> getQuoteAuthor() async {
    return _preferences?.getString(_keyQuoteAuthor);
  }

  Future<bool> setQuoteAuthor(String author) async {
    final result = await _preferences?.setString(_keyQuoteAuthor, author);
    return result ?? false;
  }

  Future<String?> getQuoteDate() async {
    return _preferences?.getString(_keyQuoteDate);
  }

  Future<bool> setQuoteDate(String date) async {
    final result = await _preferences?.setString(_keyQuoteDate, date);
    return result ?? false;
  }

  // First launch check
  Future<bool> isFirstLaunch() async {
    return _preferences?.getBool(_keyIsFirstLaunch) ?? true;
  }

  Future<bool> setFirstLaunchCompleted() async {
    final result = await _preferences?.setBool(_keyIsFirstLaunch, false);
    return result ?? false;
  }

  // Generic methods for other data types
  Future<String?> getString(String key) async {
    return _preferences?.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    final result = await _preferences?.setString(key, value);
    return result ?? false;
  }

  Future<int?> getInt(String key) async {
    return _preferences?.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    final result = await _preferences?.setInt(key, value);
    return result ?? false;
  }

  Future<bool?> getBool(String key) async {
    return _preferences?.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final result = await _preferences?.setBool(key, value);
    return result ?? false;
  }

  Future<double?> getDouble(String key) async {
    return _preferences?.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    final result = await _preferences?.setDouble(key, value);
    return result ?? false;
  }

  Future<List<String>?> getStringList(String key) async {
    return _preferences?.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final result = await _preferences?.setStringList(key, value);
    return result ?? false;
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    final result = await _preferences?.remove(key);
    return result ?? false;
  }

  // Clear all preferences
  Future<bool> clear() async {
    final result = await _preferences?.clear();
    return result ?? false;
  }

  // Check if key exists
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  // Get all keys
  Set<String> getKeys() {
    return _preferences?.getKeys() ?? <String>{};
  }
}
