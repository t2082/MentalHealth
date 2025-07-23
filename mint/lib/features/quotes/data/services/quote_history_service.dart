import 'package:mental_health/core/services/sqlite_helper.dart';
import 'package:mental_health/core/services/database_constants.dart';
import 'package:mental_health/features/quotes/domain/entities/quote.dart';

/// Service để quản lý lịch sử quotes
class QuoteHistoryService {
  final SqliteHelper _sqliteHelper;

  QuoteHistoryService(this._sqliteHelper);

  /// Lưu quote vào lịch sử
  Future<void> saveQuoteToHistory(Quote quote) async {
    try {
      await _sqliteHelper.insert(
        DatabaseConstants.emotionHistoriesTable,
        {
          DatabaseConstants.emotionHistoriesEmotion: quote.feeling,
          DatabaseConstants.emotionHistoriesQuote: quote.content,
          DatabaseConstants.emotionHistoriesAuthor: quote.author,
          DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
          DatabaseConstants.emotionHistoriesIsFavorite: DatabaseConstants.boolFalse,
        },
      );
    } catch (e) {
      print('Error saving quote to history: $e');
      rethrow;
    }
  }

  /// Lấy tất cả lịch sử quotes
  Future<List<Map<String, dynamic>>> getAllQuoteHistories() async {
    try {
      return await _sqliteHelper.getAll(
        DatabaseConstants.emotionHistoriesTable,
        orderBy: '${DatabaseConstants.emotionHistoriesCreatedAt} DESC',
      );
    } catch (e) {
      print('Error getting quote histories: $e');
      return [];
    }
  }

  /// Lấy quotes yêu thích
  Future<List<Map<String, dynamic>>> getFavoriteQuotes() async {
    try {
      return await _sqliteHelper.getFavoriteEmotionHistories();
    } catch (e) {
      print('Error getting favorite quotes: $e');
      return [];
    }
  }

  /// Toggle trạng thái yêu thích
  Future<void> toggleFavorite(int quoteId) async {
    try {
      await _sqliteHelper.toggleEmotionHistoryFavorite(quoteId);
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  /// Lấy quotes theo cảm xúc
  Future<List<Map<String, dynamic>>> getQuotesByEmotion(String emotion) async {
    try {
      return await _sqliteHelper.getWhere(
        DatabaseConstants.emotionHistoriesTable,
        where: '${DatabaseConstants.emotionHistoriesEmotion} = ?',
        whereArgs: [emotion],
        orderBy: '${DatabaseConstants.emotionHistoriesCreatedAt} DESC',
      );
    } catch (e) {
      print('Error getting quotes by emotion: $e');
      return [];
    }
  }

  /// Lấy quotes theo khoảng thời gian
  Future<List<Map<String, dynamic>>> getQuotesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _sqliteHelper.getEmotionHistoriesByDateRange(
        startDate,
        endDate,
      );
    } catch (e) {
      print('Error getting quotes by date range: $e');
      return [];
    }
  }

  /// Xóa quote khỏi lịch sử
  Future<void> deleteQuoteHistory(int quoteId) async {
    try {
      await _sqliteHelper.deleteById(
        DatabaseConstants.emotionHistoriesTable,
        quoteId,
      );
    } catch (e) {
      print('Error deleting quote history: $e');
      rethrow;
    }
  }

  /// Lấy thống kê quotes
  Future<Map<String, int>> getQuoteStats() async {
    try {
      final totalQuotes = await _sqliteHelper.count(
        DatabaseConstants.emotionHistoriesTable,
      );
      
      final favoriteQuotes = await _sqliteHelper.count(
        DatabaseConstants.emotionHistoriesTable,
        where: '${DatabaseConstants.emotionHistoriesIsFavorite} = ?',
        whereArgs: [DatabaseConstants.boolTrue],
      );

      // Đếm quotes theo từng cảm xúc
      final emotions = ['Mục tiêu', 'Vận động', 'Gắn kết', 'Tự tin'];
      final emotionCounts = <String, int>{};
      
      for (String emotion in emotions) {
        final count = await _sqliteHelper.count(
          DatabaseConstants.emotionHistoriesTable,
          where: '${DatabaseConstants.emotionHistoriesEmotion} = ?',
          whereArgs: [emotion],
        );
        emotionCounts[emotion] = count;
      }

      return {
        'total': totalQuotes,
        'favorites': favoriteQuotes,
        ...emotionCounts,
      };
    } catch (e) {
      print('Error getting quote stats: $e');
      return {};
    }
  }

  /// Kiểm tra xem quote đã tồn tại chưa (để tránh duplicate)
  Future<bool> isQuoteExists(String quoteContent, String emotion) async {
    try {
      final count = await _sqliteHelper.count(
        DatabaseConstants.emotionHistoriesTable,
        where: '${DatabaseConstants.emotionHistoriesQuote} = ? AND ${DatabaseConstants.emotionHistoriesEmotion} = ?',
        whereArgs: [quoteContent, emotion],
      );
      return count > 0;
    } catch (e) {
      print('Error checking quote existence: $e');
      return false;
    }
  }

  /// Lưu quote chỉ khi chưa tồn tại
  Future<void> saveQuoteIfNotExists(Quote quote) async {
    try {
      final exists = await isQuoteExists(quote.content, quote.feeling);
      if (!exists) {
        await saveQuoteToHistory(quote);
      }
    } catch (e) {
      print('Error saving quote if not exists: $e');
      rethrow;
    }
  }

  /// Lấy quote gần đây nhất
  Future<Map<String, dynamic>?> getLatestQuote() async {
    try {
      return await _sqliteHelper.getLatestEmotionHistory();
    } catch (e) {
      print('Error getting latest quote: $e');
      return null;
    }
  }

  /// Lấy quotes hôm nay
  Future<List<Map<String, dynamic>>> getTodayQuotes() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
      
      return await getQuotesByDateRange(startOfDay, endOfDay);
    } catch (e) {
      print('Error getting today quotes: $e');
      return [];
    }
  }

  /// Lấy quotes tuần này
  Future<List<Map<String, dynamic>>> getThisWeekQuotes() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      
      return await getQuotesByDateRange(startOfWeekDay, now);
    } catch (e) {
      print('Error getting this week quotes: $e');
      return [];
    }
  }
}
