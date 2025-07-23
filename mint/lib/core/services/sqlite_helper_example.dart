import 'dart:convert';
import 'sqlite_helper.dart';
import 'database_constants.dart';

/// Example usage của SqliteHelper
/// Đây là file hướng dẫn, không sử dụng trong production
class SqliteHelperExample {
  final SqliteHelper _db = SqliteHelper.instance;

  // ==================== EMOTION HISTORIES EXAMPLES ====================

  /// Thêm emotion history mới
  Future<void> addEmotionHistory() async {
    await _db.insert(DatabaseConstants.emotionHistoriesTable, {
      DatabaseConstants.emotionHistoriesEmotion: 'Vui vẻ',
      DatabaseConstants.emotionHistoriesQuote: 'Hạnh phúc không phải là điều gì đó có sẵn.',
      DatabaseConstants.emotionHistoriesAuthor: 'Dalai Lama',
      DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
    });
  }

  /// Lấy tất cả emotion histories
  Future<List<Map<String, dynamic>>> getAllEmotionHistories() async {
    return await _db.getAll(
      DatabaseConstants.emotionHistoriesTable,
      orderBy: '${DatabaseConstants.emotionHistoriesCreatedAt} DESC',
    );
  }

  /// Lấy emotion histories theo khoảng thời gian
  Future<List<Map<String, dynamic>>> getEmotionHistoriesInRange() async {
    final startDate = DateTime.now().subtract(const Duration(days: 7));
    final endDate = DateTime.now();
    return await _db.getEmotionHistoriesByDateRange(startDate, endDate);
  }

  // ==================== TASKS EXAMPLES ====================

  /// Thêm task mới
  Future<void> addTask() async {
    await _db.insert(DatabaseConstants.tasksTable, {
      DatabaseConstants.tasksId: 'task_001',
      DatabaseConstants.tasksTitle: 'Thiền chánh niệm',
      DatabaseConstants.tasksDescription: 'Thực hành thiền 10 phút mỗi sáng',
      DatabaseConstants.tasksCategoryId: 'spiritual',
      DatabaseConstants.tasksCategoryName: 'Tâm linh',
      DatabaseConstants.tasksCategoryDescription: 'Thiền, yoga, tâm linh',
      DatabaseConstants.tasksCategoryIconName: 'psychology',
      DatabaseConstants.tasksCategoryColorHex: '#9C27B0',
      DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
      DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
      DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityHigh,
      DatabaseConstants.tasksDueDate: DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
      DatabaseConstants.tasksTags: jsonEncode(['thiền', 'sáng', 'chánh niệm']),
      DatabaseConstants.tasksEstimatedMinutes: 10,
      DatabaseConstants.tasksNotes: 'Tập trung vào hơi thở',
    });
  }

  /// Lấy tasks chưa hoàn thành
  Future<List<Map<String, dynamic>>> getIncompleteTasks() async {
    return await _db.getTasksByCompletion(false);
  }

  /// Lấy tasks theo category
  Future<List<Map<String, dynamic>>> getTasksByCategory(String categoryId) async {
    return await _db.getTasksByCategory(categoryId);
  }

  /// Hoàn thành task
  Future<void> completeTask(String taskId) async {
    await _db.toggleTaskCompletion(taskId);
  }

  /// Lấy tasks sắp đến hạn
  Future<List<Map<String, dynamic>>> getUpcomingTasks() async {
    return await _db.getUpcomingTasks(daysAhead: 3);
  }

  // ==================== SONGS EXAMPLES ====================

  /// Thêm song mới
  Future<void> addSong() async {
    await _db.insert(DatabaseConstants.songsTable, {
      DatabaseConstants.songsId: 1,
      DatabaseConstants.songsTitle: 'Peaceful Mind',
      DatabaseConstants.songsAuthor: 'Meditation Music',
      DatabaseConstants.songsSongLink: 'https://example.com/song.mp3',
      DatabaseConstants.songsDuration: 300, // 5 minutes in seconds
      DatabaseConstants.songsIsFavorite: DatabaseConstants.boolFalse,
      DatabaseConstants.songsPlayCount: 0,
    });
  }

  /// Lấy favorite songs
  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    return await _db.getFavoriteSongs();
  }

  /// Toggle favorite song
  Future<void> toggleSongFavorite(int songId) async {
    await _db.toggleSongFavorite(songId);
  }

  /// Tăng play count
  Future<void> playSong(int songId) async {
    await _db.incrementSongPlayCount(songId);
  }

  // ==================== DAILY QUOTES EXAMPLES ====================

  /// Thêm daily quote
  Future<void> addDailyQuote() async {
    final today = DateTime.now();
    await _db.insert(DatabaseConstants.dailyQuotesTable, {
      DatabaseConstants.dailyQuotesDate: DatabaseConstants.formatDateForDailyQuote(today),
      DatabaseConstants.dailyQuotesMorningQuote: 'Mỗi ngày là một khởi đầu mới.',
      DatabaseConstants.dailyQuotesNoonQuote: 'Hãy tận hưởng khoảnh khắc hiện tại.',
      DatabaseConstants.dailyQuotesEveningQuote: 'Cảm ơn những điều tốt đẹp hôm nay.',
    });
  }

  /// Lấy daily quote hôm nay
  Future<Map<String, dynamic>?> getTodayQuote() async {
    return await _db.getDailyQuoteByDate(DateTime.now());
  }

  // ==================== USER SETTINGS EXAMPLES ====================

  /// Lưu user setting
  Future<void> saveThemeMode(String themeMode) async {
    await _db.saveUserSetting(DatabaseConstants.settingThemeMode, themeMode);
  }

  /// Lấy user setting
  Future<String?> getThemeMode() async {
    return await _db.getUserSetting(DatabaseConstants.settingThemeMode);
  }

  /// Lưu notification setting
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _db.saveUserSetting(
      DatabaseConstants.settingNotificationsEnabled,
      enabled.toString(),
    );
  }

  /// Lấy notification setting
  Future<bool> getNotificationsEnabled() async {
    final value = await _db.getUserSetting(DatabaseConstants.settingNotificationsEnabled);
    return value?.toLowerCase() == 'true';
  }

  // ==================== BATCH OPERATIONS EXAMPLES ====================

  /// Thêm nhiều tasks cùng lúc
  Future<void> addMultipleTasks() async {
    final tasks = [
      {
        DatabaseConstants.tasksId: 'task_002',
        DatabaseConstants.tasksTitle: 'Đọc sách',
        DatabaseConstants.tasksDescription: 'Đọc 30 phút mỗi ngày',
        DatabaseConstants.tasksCategoryId: 'learning',
        DatabaseConstants.tasksCategoryName: 'Học tập',
        DatabaseConstants.tasksCategoryDescription: 'Đọc sách, học hỏi',
        DatabaseConstants.tasksCategoryIconName: 'school',
        DatabaseConstants.tasksCategoryColorHex: '#2196F3',
        DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
        DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
        DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityMedium,
        DatabaseConstants.tasksTags: jsonEncode(['đọc', 'học tập']),
        DatabaseConstants.tasksEstimatedMinutes: 30,
      },
      {
        DatabaseConstants.tasksId: 'task_003',
        DatabaseConstants.tasksTitle: 'Tập thể dục',
        DatabaseConstants.tasksDescription: 'Chạy bộ 20 phút',
        DatabaseConstants.tasksCategoryId: 'physical',
        DatabaseConstants.tasksCategoryName: 'Thể chất',
        DatabaseConstants.tasksCategoryDescription: 'Tập thể dục, sức khỏe',
        DatabaseConstants.tasksCategoryIconName: 'fitness_center',
        DatabaseConstants.tasksCategoryColorHex: '#4CAF50',
        DatabaseConstants.tasksCategoryIsActive: DatabaseConstants.boolTrue,
        DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolFalse,
        DatabaseConstants.tasksPriority: DatabaseConstants.taskPriorityHigh,
        DatabaseConstants.tasksTags: jsonEncode(['thể dục', 'sức khỏe']),
        DatabaseConstants.tasksEstimatedMinutes: 20,
      },
    ];

    await _db.insertBatch(DatabaseConstants.tasksTable, tasks);
  }

  // ==================== TRANSACTION EXAMPLES ====================

  /// Thực hiện transaction để đảm bảo data consistency
  Future<void> completeTaskWithHistory() async {
    await _db.transaction((txn) async {
      // Cập nhật task completion
      await txn.update(
        DatabaseConstants.tasksTable,
        {
          DatabaseConstants.tasksIsCompleted: DatabaseConstants.boolTrue,
          DatabaseConstants.tasksCompletedAt: DatabaseConstants.getCurrentTimestamp(),
          DatabaseConstants.tasksUpdatedAt: DatabaseConstants.getCurrentTimestamp(),
        },
        where: '${DatabaseConstants.tasksId} = ?',
        whereArgs: ['task_001'],
      );

      // Thêm emotion history
      await txn.insert(DatabaseConstants.emotionHistoriesTable, {
        DatabaseConstants.emotionHistoriesEmotion: 'Hài lòng',
        DatabaseConstants.emotionHistoriesQuote: 'Hoàn thành nhiệm vụ mang lại cảm giác thành tựu.',
        DatabaseConstants.emotionHistoriesAuthor: 'Tự ghi nhận',
        DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
        DatabaseConstants.emotionHistoriesCreatedAt: DatabaseConstants.getCurrentTimestamp(),
        DatabaseConstants.emotionHistoriesUpdatedAt: DatabaseConstants.getCurrentTimestamp(),
      });
    });
  }

  // ==================== UTILITY EXAMPLES ====================

  /// Lấy thống kê database
  Future<Map<String, int>> getDatabaseStats() async {
    return {
      'emotion_histories': await _db.count(DatabaseConstants.emotionHistoriesTable),
      'tasks': await _db.count(DatabaseConstants.tasksTable),
      'completed_tasks': await _db.count(
        DatabaseConstants.tasksTable,
        where: '${DatabaseConstants.tasksIsCompleted} = ?',
        whereArgs: [DatabaseConstants.boolTrue],
      ),
      'songs': await _db.count(DatabaseConstants.songsTable),
      'favorite_songs': await _db.count(
        DatabaseConstants.songsTable,
        where: '${DatabaseConstants.songsIsFavorite} = ?',
        whereArgs: [DatabaseConstants.boolTrue],
      ),
    };
  }

  /// Reset toàn bộ dữ liệu
  Future<void> resetAllData() async {
    await _db.clearAllData();
  }

  /// Lấy thông tin database
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    return {
      'path': await _db.getDatabasePath(),
      'size_bytes': await _db.getDatabaseSize(),
    };
  }
}
