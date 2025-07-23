import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sqlite_helper.dart';
import 'database_constants.dart';

/// Helper class để migrate dữ liệu từ SharedPreferences sang SQLite
/// Sử dụng khi chuyển đổi từ local storage sang database
class DataMigrationHelper {
  final SqliteHelper _sqliteHelper;
  final SharedPreferences _prefs;

  DataMigrationHelper({
    required SqliteHelper sqliteHelper,
    required SharedPreferences prefs,
  }) : _sqliteHelper = sqliteHelper, _prefs = prefs;

  /// Migrate tất cả dữ liệu từ SharedPreferences sang SQLite
  Future<void> migrateAllData() async {
    try {
      // Check if migration has been done before
      final migrationCompleted = _prefs.getBool('migration_completed') ?? false;
      if (migrationCompleted) {
        print('Migration already completed, skipping...');
        return;
      }

      print('Starting data migration from SharedPreferences to SQLite...');

      // Migrate tasks data
      await _migrateTasks();

      // Migrate user settings
      await _migrateUserSettings();

      // Migrate emotion histories (if any)
      await _migrateEmotionHistories();

      // Mark migration as completed
      await _prefs.setBool('migration_completed', true);

      print('Data migration completed successfully!');
    } catch (e) {
      print('Error during migration: $e');
      rethrow;
    }
  }

  /// Migrate tasks từ SharedPreferences sang SQLite
  Future<void> _migrateTasks() async {
    try {
      // Lấy tasks từ SharedPreferences (format từ TaskLocalDataSourceImpl)
      final tasksJson = _prefs.getString('tasks');
      if (tasksJson == null || tasksJson.isEmpty) {
        print('No tasks found in SharedPreferences');
        return;
      }

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      print('Found ${tasksList.length} tasks to migrate');

      for (var taskJson in tasksList) {
        final task = taskJson as Map<String, dynamic>;
        
        // Convert task data to SQLite format
        final sqliteTaskData = {
          DatabaseConstants.tasksId: task['id'] ?? '',
          DatabaseConstants.tasksTitle: task['title'] ?? '',
          DatabaseConstants.tasksDescription: task['description'] ?? '',
          DatabaseConstants.tasksCategoryId: task['category']?['id'] ?? '',
          DatabaseConstants.tasksCategoryName: task['category']?['name'] ?? '',
          DatabaseConstants.tasksCategoryDescription: task['category']?['description'] ?? '',
          DatabaseConstants.tasksCategoryIconName: task['category']?['iconName'] ?? '',
          DatabaseConstants.tasksCategoryColorHex: task['category']?['colorHex'] ?? '#FF0000',
          DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolToInt(task['category']?['isActive'] ?? true),
          DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolToInt(task['isCompleted'] ?? false),
          DatabaseConstants.tasksCreatedAt: _parseDateTime(task['createdAt']),
          DatabaseConstants.tasksCompletedAt: task['completedAt'] != null ? _parseDateTime(task['completedAt']) : null,
          DatabaseConstants.tasksPriority: task['priority'] ?? DatabaseConstants.taskPriorityMedium,
          DatabaseConstants.tasksDueDate: task['dueDate'] != null ? _parseDateTime(task['dueDate']) : null,
          DatabaseConstants.tasksTags: jsonEncode(task['tags'] ?? []),
          DatabaseConstants.tasksEstimatedMinutes: task['estimatedMinutes'] ?? 30,
          DatabaseConstants.tasksNotes: task['notes'],
        };

        // Insert vào SQLite
        await _sqliteHelper.insert(DatabaseConstants.tasksTable, sqliteTaskData);
      }

      print('Successfully migrated ${tasksList.length} tasks');
    } catch (e) {
      print('Error migrating tasks: $e');
    }
  }

  /// Migrate task categories từ SharedPreferences sang SQLite
  Future<void> _migrateTaskCategories() async {
    try {
      final categoriesJson = _prefs.getString('task_categories');
      if (categoriesJson == null || categoriesJson.isEmpty) {
        print('No task categories found in SharedPreferences');
        return;
      }

      final List<dynamic> categoriesList = jsonDecode(categoriesJson);
      print('Found ${categoriesList.length} task categories to migrate');

      for (var categoryJson in categoriesList) {
        final category = categoryJson as Map<String, dynamic>;
        
        final sqliteCategoryData = {
          DatabaseConstants.taskCategoriesId: category['id'] ?? '',
          DatabaseConstants.taskCategoriesName: category['name'] ?? '',
          DatabaseConstants.taskCategoriesDescription: category['description'] ?? '',
          DatabaseConstants.taskCategoriesIconName: category['iconName'] ?? '',
          DatabaseConstants.taskCategoriesColorHex: category['colorHex'] ?? '#FF0000',
          DatabaseConstants.taskCategoriesIsActive: DatabaseConstants.boolToInt(category['isActive'] ?? true),
        };

        await _sqliteHelper.insert(DatabaseConstants.taskCategoriesTable, sqliteCategoryData);
      }

      print('Successfully migrated ${categoriesList.length} task categories');
    } catch (e) {
      print('Error migrating task categories: $e');
    }
  }

  /// Migrate user settings từ SharedPreferences sang SQLite
  Future<void> _migrateUserSettings() async {
    try {
      final settingsToMigrate = [
        'theme_mode',
        'language',
        'notifications_enabled',
        'music_volume',
        'user_name',
        'user_avatar',
        'first_launch',
      ];

      int migratedCount = 0;
      for (String key in settingsToMigrate) {
        final value = _prefs.getString(key);
        if (value != null) {
          await _sqliteHelper.saveUserSetting(key, value);
          migratedCount++;
        }
      }

      // Migrate boolean settings
      final boolSettings = [
        'notifications_enabled',
        'first_launch',
      ];

      for (String key in boolSettings) {
        if (_prefs.containsKey(key)) {
          final value = _prefs.getBool(key) ?? false;
          await _sqliteHelper.saveUserSetting(key, value.toString());
          migratedCount++;
        }
      }

      print('Successfully migrated $migratedCount user settings');
    } catch (e) {
      print('Error migrating user settings: $e');
    }
  }

  /// Migrate emotion histories (nếu có trong SharedPreferences)
  Future<void> _migrateEmotionHistories() async {
    try {
      final emotionHistoriesJson = _prefs.getString('emotion_histories');
      if (emotionHistoriesJson == null || emotionHistoriesJson.isEmpty) {
        print('No emotion histories found in SharedPreferences');
        return;
      }

      final List<dynamic> emotionsList = jsonDecode(emotionHistoriesJson);
      print('Found ${emotionsList.length} emotion histories to migrate');

      for (var emotionJson in emotionsList) {
        final emotion = emotionJson as Map<String, dynamic>;
        
        final sqliteEmotionData = {
          DatabaseConstants.emotionHistoriesEmotion: emotion['emotion'] ?? '',
          DatabaseConstants.emotionHistoriesQuote: emotion['quote'] ?? '',
          DatabaseConstants.emotionHistoriesAuthor: emotion['author'] ?? '',
          DatabaseConstants.emotionHistoriesTimestamp: emotion['timestamp'] ?? DateTime.now().toIso8601String(),
        };

        await _sqliteHelper.insert(DatabaseConstants.emotionHistoriesTable, sqliteEmotionData);
      }

      print('Successfully migrated ${emotionsList.length} emotion histories');
    } catch (e) {
      print('Error migrating emotion histories: $e');
    }
  }

  /// Parse DateTime string to timestamp
  int _parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch;
    }
    
    try {
      return DateTime.parse(dateTimeString).millisecondsSinceEpoch;
    } catch (e) {
      print('Error parsing datetime: $dateTimeString, using current time');
      return DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Backup SharedPreferences data trước khi migration
  Future<Map<String, dynamic>> backupSharedPreferencesData() async {
    final backup = <String, dynamic>{};
    
    try {
      final keys = _prefs.getKeys();
      for (String key in keys) {
        final value = _prefs.get(key);
        backup[key] = value;
      }
      
      print('Backed up ${backup.length} SharedPreferences entries');
    } catch (e) {
      print('Error creating backup: $e');
    }
    
    return backup;
  }

  /// Restore SharedPreferences data từ backup
  Future<void> restoreSharedPreferencesData(Map<String, dynamic> backup) async {
    try {
      for (var entry in backup.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is String) {
          await _prefs.setString(key, value);
        } else if (value is int) {
          await _prefs.setInt(key, value);
        } else if (value is double) {
          await _prefs.setDouble(key, value);
        } else if (value is bool) {
          await _prefs.setBool(key, value);
        } else if (value is List<String>) {
          await _prefs.setStringList(key, value);
        }
      }
      
      print('Restored ${backup.length} SharedPreferences entries');
    } catch (e) {
      print('Error restoring backup: $e');
    }
  }

  /// Kiểm tra xem migration đã hoàn thành chưa
  bool isMigrationCompleted() {
    return _prefs.getBool('migration_completed') ?? false;
  }

  /// Reset migration flag (for testing)
  Future<void> resetMigrationFlag() async {
    await _prefs.setBool('migration_completed', false);
  }

  /// Lấy thống kê migration
  Future<Map<String, int>> getMigrationStats() async {
    return {
      'tasks_count': await _sqliteHelper.count(DatabaseConstants.tasksTable),
      'task_categories_count': await _sqliteHelper.count(DatabaseConstants.taskCategoriesTable),
      'emotion_histories_count': await _sqliteHelper.count(DatabaseConstants.emotionHistoriesTable),
      'user_settings_count': await _sqliteHelper.count(DatabaseConstants.userSettingsTable),
    };
  }
}
