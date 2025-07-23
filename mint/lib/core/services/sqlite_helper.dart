import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Generic SQLite Helper dùng chung cho toàn bộ ứng dụng
/// Hỗ trợ CRUD operations cho nhiều bảng khác nhau
class SqliteHelper {
  static final SqliteHelper instance = SqliteHelper._init();
  static Database? _database;

  // Database configuration
  static const String _databaseName = 'mint_app.db';
  static const int _databaseVersion = 1;

  SqliteHelper._init();

  /// Lấy database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Khởi tạo database
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  /// Tạo các bảng khi database được tạo lần đầu
  Future<void> _createDB(Database db, int version) async {
    await db.transaction((txn) async {
      // Bảng emotion histories
      await txn.execute('''
        CREATE TABLE emotion_histories(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          emotion TEXT NOT NULL,
          quote TEXT NOT NULL,
          author TEXT NOT NULL,
          timestamp TEXT NOT NULL,
          is_favorite INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng tasks
      await txn.execute('''
        CREATE TABLE tasks(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          category_id TEXT NOT NULL,
          category_name TEXT NOT NULL,
          category_description TEXT NOT NULL,
          category_icon_name TEXT NOT NULL,
          category_color_hex TEXT NOT NULL,
          category_is_active INTEGER NOT NULL DEFAULT 1,
          is_completed INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          completed_at INTEGER,
          priority INTEGER NOT NULL DEFAULT 2,
          due_date INTEGER,
          tags TEXT NOT NULL DEFAULT '[]',
          estimated_minutes INTEGER NOT NULL DEFAULT 30,
          notes TEXT,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng task categories
      await txn.execute('''
        CREATE TABLE task_categories(
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          icon_name TEXT NOT NULL,
          color_hex TEXT NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng songs
      await txn.execute('''
        CREATE TABLE songs(
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          author TEXT NOT NULL,
          song_link TEXT NOT NULL,
          duration INTEGER,
          is_favorite INTEGER NOT NULL DEFAULT 0,
          play_count INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng daily quotes
      await txn.execute('''
        CREATE TABLE daily_quotes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          morning_quote TEXT NOT NULL,
          noon_quote TEXT NOT NULL,
          evening_quote TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng user connections
      await txn.execute('''
        CREATE TABLE user_connections(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_name TEXT NOT NULL,
          avatar TEXT NOT NULL,
          emotion TEXT NOT NULL,
          status TEXT NOT NULL,
          distance TEXT NOT NULL,
          is_premium INTEGER NOT NULL DEFAULT 0,
          is_online INTEGER NOT NULL DEFAULT 0,
          last_active INTEGER,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng diary entries
      await txn.execute('''
        CREATE TABLE diary_entries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          author TEXT NOT NULL,
          avatar TEXT NOT NULL,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          preview TEXT NOT NULL,
          emotion TEXT NOT NULL,
          price INTEGER NOT NULL DEFAULT 0,
          likes INTEGER NOT NULL DEFAULT 0,
          is_premium INTEGER NOT NULL DEFAULT 0,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng user settings
      await txn.execute('''
        CREATE TABLE user_settings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT NOT NULL UNIQUE,
          value TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Bảng trees
      await txn.execute('''
        CREATE TABLE trees(
          id TEXT PRIMARY KEY,
          growth REAL NOT NULL DEFAULT 0.0,
          seed INTEGER NOT NULL,
          name TEXT,
          created_at TEXT NOT NULL,
          last_updated TEXT NOT NULL
        )
      ''');
    });
  }

  /// Upgrade database khi version thay đổi
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Implement migration logic here when needed
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE tasks ADD COLUMN new_field TEXT');
    // }
  }

  // ==================== GENERIC CRUD OPERATIONS ====================

  /// Insert một record vào bảng chỉ định
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Tạo bản sao của data để tránh modify original map
    final dataToInsert = Map<String, dynamic>.from(data);

    // Tự động thêm timestamps nếu chưa có
    if (!dataToInsert.containsKey('created_at')) {
      dataToInsert['created_at'] = now;
    }
    if (!dataToInsert.containsKey('updated_at')) {
      dataToInsert['updated_at'] = now;
    }

    return await db.insert(table, dataToInsert);
  }

  /// Insert nhiều records cùng lúc (batch insert)
  Future<List<int>> insertBatch(
      String table, List<Map<String, dynamic>> dataList) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Tạo bản sao của dataList để tránh modify original maps
    final dataListToInsert = dataList.map((data) {
      final dataToInsert = Map<String, dynamic>.from(data);

      // Tự động thêm timestamps nếu chưa có
      if (!dataToInsert.containsKey('created_at')) {
        dataToInsert['created_at'] = now;
      }
      if (!dataToInsert.containsKey('updated_at')) {
        dataToInsert['updated_at'] = now;
      }

      return dataToInsert;
    }).toList();

    final batch = db.batch();
    for (var data in dataListToInsert) {
      batch.insert(table, data);
    }

    final results = await batch.commit();
    return results.cast<int>();
  }

  /// Lấy tất cả records từ bảng
  Future<List<Map<String, dynamic>>> getAll(
    String table, {
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Lấy record theo ID
  Future<Map<String, dynamic>?> getById(String table, dynamic id,
      {String idColumn = 'id'}) async {
    final db = await database;
    final results = await db.query(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
      limit: 1,
    );

    return results.isNotEmpty ? results.first : null;
  }

  /// Lấy records theo điều kiện
  Future<List<Map<String, dynamic>>> getWhere(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Update record theo ID
  Future<int> updateById(String table, dynamic id, Map<String, dynamic> data,
      {String idColumn = 'id'}) async {
    final db = await database;

    // Tự động cập nhật updated_at
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      table,
      data,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  /// Update records theo điều kiện
  Future<int> updateWhere(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;

    // Tự động cập nhật updated_at
    data['updated_at'] = DateTime.now().millisecondsSinceEpoch;

    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Delete record theo ID
  Future<int> deleteById(String table, dynamic id,
      {String idColumn = 'id'}) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  /// Delete records theo điều kiện
  Future<int> deleteWhere(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  /// Đếm số lượng records trong bảng
  Future<int> count(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return result.first['count'] as int;
  }

  /// Kiểm tra record có tồn tại không
  Future<bool> exists(String table, dynamic id,
      {String idColumn = 'id'}) async {
    final count =
        await this.count(table, where: '$idColumn = ?', whereArgs: [id]);
    return count > 0;
  }

  // ==================== TRANSACTION SUPPORT ====================

  /// Thực hiện transaction
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  /// Thực hiện batch operations
  Future<List<dynamic>> batch(void Function(Batch batch) operations) async {
    final db = await database;
    final batch = db.batch();
    operations(batch);
    return await batch.commit();
  }

  // ==================== SPECIALIZED METHODS ====================

  /// Lấy emotion history gần đây nhất
  Future<Map<String, dynamic>?> getLatestEmotionHistory() async {
    final results = await getWhere(
      'emotion_histories',
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Lấy emotion histories theo khoảng thời gian
  Future<List<Map<String, dynamic>>> getEmotionHistoriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await getWhere(
      'emotion_histories',
      where: 'created_at >= ? AND created_at <= ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch
      ],
      orderBy: 'created_at DESC',
    );
  }

  /// Lấy favorite emotion histories
  Future<List<Map<String, dynamic>>> getFavoriteEmotionHistories() async {
    return await getWhere(
      'emotion_histories',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
  }

  /// Toggle favorite emotion history
  Future<int> toggleEmotionHistoryFavorite(int emotionHistoryId) async {
    final emotionHistory = await getById('emotion_histories', emotionHistoryId);
    if (emotionHistory == null) return 0;

    final isFavorite = emotionHistory['is_favorite'] == 1;
    return await updateById('emotion_histories', emotionHistoryId, {
      'is_favorite': isFavorite ? 0 : 1,
    });
  }

  /// Lấy tasks theo trạng thái hoàn thành
  Future<List<Map<String, dynamic>>> getTasksByCompletion(
      bool isCompleted) async {
    return await getWhere(
      'tasks',
      where: 'is_completed = ?',
      whereArgs: [isCompleted ? 1 : 0],
      orderBy: 'created_at DESC',
    );
  }

  /// Lấy tasks theo category
  Future<List<Map<String, dynamic>>> getTasksByCategory(
      String categoryId) async {
    return await getWhere(
      'tasks',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'created_at DESC',
    );
  }

  /// Lấy tasks theo priority
  Future<List<Map<String, dynamic>>> getTasksByPriority(int priority) async {
    return await getWhere(
      'tasks',
      where: 'priority = ?',
      whereArgs: [priority],
      orderBy: 'due_date ASC, created_at DESC',
    );
  }

  /// Lấy tasks sắp đến hạn
  Future<List<Map<String, dynamic>>> getUpcomingTasks(
      {int daysAhead = 7}) async {
    final now = DateTime.now();
    final futureDate = now.add(Duration(days: daysAhead));

    return await getWhere(
      'tasks',
      where:
          'due_date IS NOT NULL AND due_date >= ? AND due_date <= ? AND is_completed = 0',
      whereArgs: [
        now.millisecondsSinceEpoch,
        futureDate.millisecondsSinceEpoch
      ],
      orderBy: 'due_date ASC',
    );
  }

  /// Toggle task completion
  Future<int> toggleTaskCompletion(String taskId) async {
    final task = await getById('tasks', taskId);
    if (task == null) return 0;

    final isCompleted = task['is_completed'] == 1;
    final now = DateTime.now().millisecondsSinceEpoch;

    return await updateById('tasks', taskId, {
      'is_completed': isCompleted ? 0 : 1,
      'completed_at': isCompleted ? null : now,
    });
  }

  /// Lấy daily quote theo ngày
  Future<Map<String, dynamic>?> getDailyQuoteByDate(DateTime date) async {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final results = await getWhere(
      'daily_quotes',
      where: 'date = ?',
      whereArgs: [dateString],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Lấy favorite songs
  Future<List<Map<String, dynamic>>> getFavoriteSongs() async {
    return await getWhere(
      'songs',
      where: 'is_favorite = 1',
      orderBy: 'title ASC',
    );
  }

  /// Cập nhật play count cho song
  Future<int> incrementSongPlayCount(int songId) async {
    final song = await getById('songs', songId);
    if (song == null) return 0;

    final currentCount = song['play_count'] as int? ?? 0;
    return await updateById('songs', songId, {
      'play_count': currentCount + 1,
    });
  }

  /// Toggle favorite song
  Future<int> toggleSongFavorite(int songId) async {
    final song = await getById('songs', songId);
    if (song == null) return 0;

    final isFavorite = song['is_favorite'] == 1;
    return await updateById('songs', songId, {
      'is_favorite': isFavorite ? 0 : 1,
    });
  }

  /// Lấy user setting theo key
  Future<String?> getUserSetting(String key) async {
    final result = await getWhere(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return result.isNotEmpty ? result.first['value'] as String : null;
  }

  /// Lưu user setting
  Future<void> saveUserSetting(String key, String value) async {
    final existing = await getWhere(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      await updateWhere(
        'user_settings',
        {'value': value},
        where: 'key = ?',
        whereArgs: [key],
      );
    } else {
      await insert('user_settings', {
        'key': key,
        'value': value,
      });
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Xóa toàn bộ dữ liệu (reset app)
  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('emotion_histories');
      await txn.delete('tasks');
      await txn.delete('task_categories');
      await txn.delete('songs');
      await txn.delete('daily_quotes');
      await txn.delete('user_connections');
      await txn.delete('diary_entries');
      await txn.delete('user_settings');
    });
  }

  /// Đóng database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Lấy database path (for debugging)
  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, _databaseName);
  }

  /// Lấy database size (for debugging)
  Future<int> getDatabaseSize() async {
    final path = await getDatabasePath();
    final file = await File(path).stat();
    return file.size;
  }
}
