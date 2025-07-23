/// Constants cho database tables và columns
/// Giúp tránh lỗi typo và dễ dàng maintain
class DatabaseConstants {
  // ==================== TABLE NAMES ====================
  static const String emotionHistoriesTable = 'emotion_histories';
  static const String tasksTable = 'tasks';
  static const String taskCategoriesTable = 'task_categories';
  static const String songsTable = 'songs';
  static const String dailyQuotesTable = 'daily_quotes';
  static const String userConnectionsTable = 'user_connections';
  static const String diaryEntriesTable = 'diary_entries';
  static const String userSettingsTable = 'user_settings';
  static const String treesTable = 'trees';

  // ==================== EMOTION HISTORIES COLUMNS ====================
  static const String emotionHistoriesId = 'id';
  static const String emotionHistoriesEmotion = 'emotion';
  static const String emotionHistoriesQuote = 'quote';
  static const String emotionHistoriesAuthor = 'author';
  static const String emotionHistoriesTimestamp = 'timestamp';
  static const String emotionHistoriesIsFavorite = 'is_favorite';
  static const String emotionHistoriesCreatedAt = 'created_at';
  static const String emotionHistoriesUpdatedAt = 'updated_at';

  // ==================== TASKS COLUMNS ====================
  static const String tasksId = 'id';
  static const String tasksTitle = 'title';
  static const String tasksDescription = 'description';
  static const String tasksCategoryId = 'category_id';
  static const String tasksCategoryName = 'category_name';
  static const String tasksCategoryDescription = 'category_description';
  static const String tasksCategoryIconName = 'category_icon_name';
  static const String tasksCategoryColorHex = 'category_color_hex';
  static const String tasksCategoryIsActive = 'category_is_active';
  static const String tasksIsCompleted = 'is_completed';
  static const String tasksCreatedAt = 'created_at';
  static const String tasksCompletedAt = 'completed_at';
  static const String tasksPriority = 'priority';
  static const String tasksDueDate = 'due_date';
  static const String tasksTags = 'tags';
  static const String tasksEstimatedMinutes = 'estimated_minutes';
  static const String tasksNotes = 'notes';
  static const String tasksUpdatedAt = 'updated_at';

  // ==================== TASK CATEGORIES COLUMNS ====================
  static const String taskCategoriesId = 'id';
  static const String taskCategoriesName = 'name';
  static const String taskCategoriesDescription = 'description';
  static const String taskCategoriesIconName = 'icon_name';
  static const String taskCategoriesColorHex = 'color_hex';
  static const String taskCategoriesIsActive = 'is_active';
  static const String taskCategoriesCreatedAt = 'created_at';
  static const String taskCategoriesUpdatedAt = 'updated_at';

  // ==================== SONGS COLUMNS ====================
  static const String songsId = 'id';
  static const String songsTitle = 'title';
  static const String songsAuthor = 'author';
  static const String songsSongLink = 'song_link';
  static const String songsDuration = 'duration';
  static const String songsIsFavorite = 'is_favorite';
  static const String songsPlayCount = 'play_count';
  static const String songsCreatedAt = 'created_at';
  static const String songsUpdatedAt = 'updated_at';

  // ==================== DAILY QUOTES COLUMNS ====================
  static const String dailyQuotesId = 'id';
  static const String dailyQuotesDate = 'date';
  static const String dailyQuotesMorningQuote = 'morning_quote';
  static const String dailyQuotesNoonQuote = 'noon_quote';
  static const String dailyQuotesEveningQuote = 'evening_quote';
  static const String dailyQuotesCreatedAt = 'created_at';
  static const String dailyQuotesUpdatedAt = 'updated_at';

  // ==================== USER CONNECTIONS COLUMNS ====================
  static const String userConnectionsId = 'id';
  static const String userConnectionsUserName = 'user_name';
  static const String userConnectionsAvatar = 'avatar';
  static const String userConnectionsEmotion = 'emotion';
  static const String userConnectionsStatus = 'status';
  static const String userConnectionsDistance = 'distance';
  static const String userConnectionsIsPremium = 'is_premium';
  static const String userConnectionsIsOnline = 'is_online';
  static const String userConnectionsLastActive = 'last_active';
  static const String userConnectionsCreatedAt = 'created_at';
  static const String userConnectionsUpdatedAt = 'updated_at';

  // ==================== DIARY ENTRIES COLUMNS ====================
  static const String diaryEntriesId = 'id';
  static const String diaryEntriesAuthor = 'author';
  static const String diaryEntriesAvatar = 'avatar';
  static const String diaryEntriesTitle = 'title';
  static const String diaryEntriesContent = 'content';
  static const String diaryEntriesPreview = 'preview';
  static const String diaryEntriesEmotion = 'emotion';
  static const String diaryEntriesPrice = 'price';
  static const String diaryEntriesLikes = 'likes';
  static const String diaryEntriesIsPremium = 'is_premium';
  static const String diaryEntriesCreatedAt = 'created_at';
  static const String diaryEntriesUpdatedAt = 'updated_at';

  // ==================== USER SETTINGS COLUMNS ====================
  static const String userSettingsId = 'id';
  static const String userSettingsKey = 'key';
  static const String userSettingsValue = 'value';
  static const String userSettingsCreatedAt = 'created_at';
  static const String userSettingsUpdatedAt = 'updated_at';

  // ==================== TREES COLUMNS ====================
  static const String treesId = 'id';
  static const String treesGrowth = 'growth';
  static const String treesSeed = 'seed';
  static const String treesName = 'name';
  static const String treesCreatedAt = 'created_at';
  static const String treesLastUpdated = 'last_updated';

  // ==================== COMMON COLUMNS ====================
  static const String commonId = 'id';
  static const String commonCreatedAt = 'created_at';
  static const String commonUpdatedAt = 'updated_at';

  // ==================== TASK PRIORITIES ====================
  static const int taskPriorityLow = 1;
  static const int taskPriorityMedium = 2;
  static const int taskPriorityHigh = 3;

  // ==================== BOOLEAN VALUES ====================
  static const int boolTrue = 1;
  static const int boolFalse = 0;

  // ==================== COMMON SETTINGS KEYS ====================
  static const String settingThemeMode = 'theme_mode';
  static const String settingLanguage = 'language';
  static const String settingNotificationsEnabled = 'notifications_enabled';
  static const String settingMusicVolume = 'music_volume';
  static const String settingLastBackupDate = 'last_backup_date';
  static const String settingUserName = 'user_name';
  static const String settingUserAvatar = 'user_avatar';
  static const String settingFirstLaunch = 'first_launch';

  // ==================== HELPER METHODS ====================

  /// Convert boolean to integer for SQLite storage
  static int boolToInt(bool value) => value ? boolTrue : boolFalse;

  /// Convert integer to boolean from SQLite storage
  static bool intToBool(int value) => value == boolTrue;

  /// Get current timestamp in milliseconds
  static int getCurrentTimestamp() => DateTime.now().millisecondsSinceEpoch;

  /// Convert DateTime to timestamp for SQLite storage
  static int dateTimeToTimestamp(DateTime dateTime) =>
      dateTime.millisecondsSinceEpoch;

  /// Convert timestamp to DateTime from SQLite storage
  static DateTime timestampToDateTime(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Format date for daily quotes (YYYY-MM-DD)
  static String formatDateForDailyQuote(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get priority name from priority value
  static String getPriorityName(int priority) {
    switch (priority) {
      case taskPriorityLow:
        return 'Thấp';
      case taskPriorityMedium:
        return 'Trung bình';
      case taskPriorityHigh:
        return 'Cao';
      default:
        return 'Trung bình';
    }
  }

  /// Get priority color from priority value
  static String getPriorityColor(int priority) {
    switch (priority) {
      case taskPriorityLow:
        return '#4CAF50'; // Green
      case taskPriorityMedium:
        return '#FF9800'; // Orange
      case taskPriorityHigh:
        return '#F44336'; // Red
      default:
        return '#FF9800'; // Orange
    }
  }
}
