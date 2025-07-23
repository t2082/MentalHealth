# SQLite Helper - Hướng dẫn sử dụng

## Tổng quan

`SqliteHelper` là một class dùng chung cho toàn bộ ứng dụng Flutter mental health, cung cấp các phương thức CRUD generic và chuyên biệt cho các module khác nhau.

## Cấu trúc Database

### Các bảng chính:
- **emotion_histories**: Lưu trữ lịch sử cảm xúc và quotes
- **tasks**: Quản lý nhiệm vụ và công việc
- **task_categories**: Danh mục nhiệm vụ
- **songs**: Thư viện nhạc thiền
- **daily_quotes**: Quotes hàng ngày
- **user_connections**: Kết nối người dùng
- **diary_entries**: Nhật ký cảm xúc
- **user_settings**: Cài đặt ứng dụng

## Cách sử dụng cơ bản

### 1. Khởi tạo
```dart
final SqliteHelper db = SqliteHelper.instance;
```

### 2. CRUD Operations cơ bản

#### Insert
```dart
// Insert một record
await db.insert('tasks', {
  'id': 'task_001',
  'title': 'Thiền chánh niệm',
  'description': 'Thực hành thiền 10 phút',
  // ... other fields
});

// Insert nhiều records
await db.insertBatch('tasks', [
  {'id': 'task_001', 'title': 'Task 1'},
  {'id': 'task_002', 'title': 'Task 2'},
]);
```

#### Select
```dart
// Lấy tất cả records
final allTasks = await db.getAll('tasks');

// Lấy record theo ID
final task = await db.getById('tasks', 'task_001');

// Lấy records theo điều kiện
final completedTasks = await db.getWhere(
  'tasks',
  where: 'is_completed = ?',
  whereArgs: [1],
  orderBy: 'created_at DESC',
);
```

#### Update
```dart
// Update theo ID
await db.updateById('tasks', 'task_001', {
  'is_completed': 1,
  'completed_at': DateTime.now().millisecondsSinceEpoch,
});

// Update theo điều kiện
await db.updateWhere(
  'tasks',
  {'priority': 3},
  where: 'category_id = ?',
  whereArgs: ['urgent'],
);
```

#### Delete
```dart
// Delete theo ID
await db.deleteById('tasks', 'task_001');

// Delete theo điều kiện
await db.deleteWhere(
  'tasks',
  where: 'is_completed = ? AND created_at < ?',
  whereArgs: [1, oldTimestamp],
);
```

### 3. Phương thức chuyên biệt

#### Tasks
```dart
// Lấy tasks chưa hoàn thành
final incompleteTasks = await db.getTasksByCompletion(false);

// Lấy tasks theo category
final spiritualTasks = await db.getTasksByCategory('spiritual');

// Lấy tasks sắp đến hạn
final upcomingTasks = await db.getUpcomingTasks(daysAhead: 7);

// Toggle task completion
await db.toggleTaskCompletion('task_001');
```

#### Emotions
```dart
// Lấy emotion history gần nhất
final latestEmotion = await db.getLatestEmotionHistory();

// Lấy emotion histories theo khoảng thời gian
final weeklyEmotions = await db.getEmotionHistoriesByDateRange(
  DateTime.now().subtract(Duration(days: 7)),
  DateTime.now(),
);
```

#### Music
```dart
// Lấy favorite songs
final favoriteSongs = await db.getFavoriteSongs();

// Toggle favorite
await db.toggleSongFavorite(songId);

// Tăng play count
await db.incrementSongPlayCount(songId);
```

#### Settings
```dart
// Lưu setting
await db.saveUserSetting('theme_mode', 'dark');

// Lấy setting
final themeMode = await db.getUserSetting('theme_mode');
```

### 4. Transactions

```dart
// Thực hiện transaction
await db.transaction((txn) async {
  await txn.insert('tasks', taskData);
  await txn.insert('emotion_histories', emotionData);
});

// Batch operations
await db.batch((batch) {
  batch.insert('tasks', task1Data);
  batch.insert('tasks', task2Data);
  batch.update('user_settings', settingData, where: 'key = ?', whereArgs: ['theme']);
});
```

## Constants

Sử dụng `DatabaseConstants` để tránh lỗi typo:

```dart
import 'database_constants.dart';

// Table names
DatabaseConstants.tasksTable
DatabaseConstants.emotionHistoriesTable

// Column names
DatabaseConstants.tasksTitle
DatabaseConstants.tasksIsCompleted

// Common values
DatabaseConstants.taskPriorityHigh
DatabaseConstants.boolTrue
DatabaseConstants.boolFalse
```

## Helper Methods

```dart
// Convert boolean to int for SQLite
final intValue = DatabaseConstants.boolToInt(true); // 1

// Convert int to boolean from SQLite
final boolValue = DatabaseConstants.intToBool(1); // true

// Get current timestamp
final timestamp = DatabaseConstants.getCurrentTimestamp();

// Format date for daily quotes
final dateString = DatabaseConstants.formatDateForDailyQuote(DateTime.now());
```

## Utility Methods

```dart
// Đếm records
final taskCount = await db.count('tasks');

// Kiểm tra tồn tại
final exists = await db.exists('tasks', 'task_001');

// Xóa toàn bộ dữ liệu
await db.clearAllData();

// Lấy thông tin database
final dbPath = await db.getDatabasePath();
final dbSize = await db.getDatabaseSize();

// Đóng database
await db.close();
```

## Best Practices

1. **Sử dụng Constants**: Luôn sử dụng `DatabaseConstants` thay vì hardcode strings
2. **Timestamps**: Database tự động thêm `created_at` và `updated_at`
3. **Transactions**: Sử dụng transactions cho operations phức tạp
4. **Error Handling**: Wrap database calls trong try-catch
5. **Performance**: Sử dụng batch operations cho multiple inserts
6. **Memory**: Đóng database khi không cần thiết

## Migration

Khi cần thay đổi schema, update `_databaseVersion` và implement logic trong `_upgradeDB`:

```dart
Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('ALTER TABLE tasks ADD COLUMN new_field TEXT');
  }
  if (oldVersion < 3) {
    await db.execute('CREATE TABLE new_table(...)');
  }
}
```

## Testing

Xem file `sqlite_helper_example.dart` để có ví dụ chi tiết về cách sử dụng tất cả các tính năng.
