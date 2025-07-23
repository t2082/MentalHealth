import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mental_health/core/services/sqlite_helper.dart';
import 'package:mental_health/core/services/database_constants.dart';

void main() {
  late SqliteHelper sqliteHelper;

  setUpAll(() {
    // Initialize FFI for testing
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    sqliteHelper = SqliteHelper.instance;
  });

  tearDown(() async {
    // Clean up after each test
    await sqliteHelper.clearAllData();
  });

  group('SqliteHelper Tests', () {
    test('should create database and tables successfully', () async {
      final db = await sqliteHelper.database;
      expect(db, isNotNull);
      expect(db.isOpen, isTrue);
    });

    test('should insert and retrieve emotion history', () async {
      // Insert emotion history
      final emotionData = {
        DatabaseConstants.emotionHistoriesEmotion: 'Vui vẻ',
        DatabaseConstants.emotionHistoriesQuote: 'Test quote',
        DatabaseConstants.emotionHistoriesAuthor: 'Test author',
        DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
      };

      final id = await sqliteHelper.insert(
        DatabaseConstants.emotionHistoriesTable,
        emotionData,
      );

      expect(id, greaterThan(0));

      // Retrieve emotion history
      final retrieved = await sqliteHelper.getById(
        DatabaseConstants.emotionHistoriesTable,
        id,
      );

      expect(retrieved, isNotNull);
      expect(retrieved![DatabaseConstants.emotionHistoriesEmotion], equals('Vui vẻ'));
      expect(retrieved[DatabaseConstants.emotionHistoriesQuote], equals('Test quote'));
    });

    test('should insert and retrieve task', () async {
      // Insert task
      final taskData = {
        DatabaseConstants.tasksId: 'test_task_001',
        DatabaseConstants.tasksTitle: 'Test Task',
        DatabaseConstants.tasksDescription: 'Test Description',
        DatabaseConstants.tasksCategoryId: 'test_category',
        DatabaseConstants.tasksCategoryName: 'Test Category',
        DatabaseConstants.tasksCategoryDescription: 'Test Category Description',
        DatabaseConstants.tasksCategoryIconName: 'test_icon',
        DatabaseConstants.tasksCategoryColorHex: '#FF0000',
        DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
        DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
        DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityMedium,
        DatabaseConstants.tasksTags: '["test", "task"]',
        DatabaseConstants.tasksEstimatedMinutes: 30,
      };

      await sqliteHelper.insert(DatabaseConstants.tasksTable, taskData);

      // Retrieve task
      final retrieved = await sqliteHelper.getById(
        DatabaseConstants.tasksTable,
        'test_task_001',
      );

      expect(retrieved, isNotNull);
      expect(retrieved![DatabaseConstants.tasksTitle], equals('Test Task'));
      expect(retrieved[DatabaseConstants.tasksIsCompleted], equals(DatabaseConstants.boolFalse));
    });

    test('should toggle task completion', () async {
      // Insert task
      final taskData = {
        DatabaseConstants.tasksId: 'toggle_task_001',
        DatabaseConstants.tasksTitle: 'Toggle Task',
        DatabaseConstants.tasksDescription: 'Test Description',
        DatabaseConstants.tasksCategoryId: 'test_category',
        DatabaseConstants.tasksCategoryName: 'Test Category',
        DatabaseConstants.tasksCategoryDescription: 'Test Category Description',
        DatabaseConstants.tasksCategoryIconName: 'test_icon',
        DatabaseConstants.tasksCategoryColorHex: '#FF0000',
        DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
        DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
        DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityMedium,
        DatabaseConstants.tasksTags: '["test"]',
        DatabaseConstants.tasksEstimatedMinutes: 30,
      };

      await sqliteHelper.insert(DatabaseConstants.tasksTable, taskData);

      // Toggle completion
      await sqliteHelper.toggleTaskCompletion('toggle_task_001');

      // Check if task is completed
      final retrieved = await sqliteHelper.getById(
        DatabaseConstants.tasksTable,
        'toggle_task_001',
      );

      expect(retrieved![DatabaseConstants.tasksIsCompleted], equals(DatabaseConstants.boolTrue));
      expect(retrieved[DatabaseConstants.tasksCompletedAt], isNotNull);
    });

    test('should save and retrieve user settings', () async {
      // Save setting
      await sqliteHelper.saveUserSetting('test_key', 'test_value');

      // Retrieve setting
      final value = await sqliteHelper.getUserSetting('test_key');

      expect(value, equals('test_value'));

      // Update setting
      await sqliteHelper.saveUserSetting('test_key', 'updated_value');

      // Retrieve updated setting
      final updatedValue = await sqliteHelper.getUserSetting('test_key');

      expect(updatedValue, equals('updated_value'));
    });

    test('should count records correctly', () async {
      // Insert multiple emotion histories
      for (int i = 0; i < 5; i++) {
        await sqliteHelper.insert(DatabaseConstants.emotionHistoriesTable, {
          DatabaseConstants.emotionHistoriesEmotion: 'Emotion $i',
          DatabaseConstants.emotionHistoriesQuote: 'Quote $i',
          DatabaseConstants.emotionHistoriesAuthor: 'Author $i',
          DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
        });
      }

      final count = await sqliteHelper.count(DatabaseConstants.emotionHistoriesTable);
      expect(count, equals(5));
    });

    test('should perform batch insert', () async {
      final emotionDataList = List.generate(3, (index) => {
        DatabaseConstants.emotionHistoriesEmotion: 'Emotion $index',
        DatabaseConstants.emotionHistoriesQuote: 'Quote $index',
        DatabaseConstants.emotionHistoriesAuthor: 'Author $index',
        DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
      });

      final results = await sqliteHelper.insertBatch(
        DatabaseConstants.emotionHistoriesTable,
        emotionDataList,
      );

      expect(results.length, equals(3));
      expect(results.every((id) => id > 0), isTrue);

      final count = await sqliteHelper.count(DatabaseConstants.emotionHistoriesTable);
      expect(count, equals(3));
    });

    test('should check if record exists', () async {
      // Insert task
      await sqliteHelper.insert(DatabaseConstants.tasksTable, {
        DatabaseConstants.tasksId: 'exists_task_001',
        DatabaseConstants.tasksTitle: 'Exists Task',
        DatabaseConstants.tasksDescription: 'Test Description',
        DatabaseConstants.tasksCategoryId: 'test_category',
        DatabaseConstants.tasksCategoryName: 'Test Category',
        DatabaseConstants.tasksCategoryDescription: 'Test Category Description',
        DatabaseConstants.tasksCategoryIconName: 'test_icon',
        DatabaseConstants.tasksCategoryColorHex: '#FF0000',
        DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
        DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
        DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityMedium,
        DatabaseConstants.tasksTags: '["test"]',
        DatabaseConstants.tasksEstimatedMinutes: 30,
      });

      // Check existence
      final exists = await sqliteHelper.exists(
        DatabaseConstants.tasksTable,
        'exists_task_001',
      );
      expect(exists, isTrue);

      // Check non-existence
      final notExists = await sqliteHelper.exists(
        DatabaseConstants.tasksTable,
        'non_existent_task',
      );
      expect(notExists, isFalse);
    });

    test('should clear all data', () async {
      // Insert some data
      await sqliteHelper.insert(DatabaseConstants.emotionHistoriesTable, {
        DatabaseConstants.emotionHistoriesEmotion: 'Test',
        DatabaseConstants.emotionHistoriesQuote: 'Test',
        DatabaseConstants.emotionHistoriesAuthor: 'Test',
        DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
      });

      await sqliteHelper.saveUserSetting('test_key', 'test_value');

      // Clear all data
      await sqliteHelper.clearAllData();

      // Check if data is cleared
      final emotionCount = await sqliteHelper.count(DatabaseConstants.emotionHistoriesTable);
      final settingValue = await sqliteHelper.getUserSetting('test_key');

      expect(emotionCount, equals(0));
      expect(settingValue, isNull);
    });
  });

  group('DatabaseConstants Tests', () {
    test('should convert boolean to int correctly', () {
      expect(DatabaseConstants.boolToInt(true), equals(1));
      expect(DatabaseConstants.boolToInt(false), equals(0));
    });

    test('should convert int to boolean correctly', () {
      expect(DatabaseConstants.intToBool(1), isTrue);
      expect(DatabaseConstants.intToBool(0), isFalse);
    });

    test('should format date correctly', () {
      final date = DateTime(2024, 1, 5);
      final formatted = DatabaseConstants.formatDateForDailyQuote(date);
      expect(formatted, equals('2024-01-05'));
    });

    test('should get priority name correctly', () {
      expect(DatabaseConstants.getPriorityName(DatabaseConstants.taskPriorityLow), equals('Thấp'));
      expect(DatabaseConstants.getPriorityName(DatabaseConstants.taskPriorityMedium), equals('Trung bình'));
      expect(DatabaseConstants.getPriorityName(DatabaseConstants.taskPriorityHigh), equals('Cao'));
    });
  });
}
