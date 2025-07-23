import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mental_health/injection_container.dart' as di;
import 'sqlite_helper.dart';
import 'database_constants.dart';

/// Example integration của SqliteHelper với ứng dụng thực tế
/// Đây là file demo, có thể sử dụng làm reference
class SqliteIntegrationExample extends StatefulWidget {
  const SqliteIntegrationExample({super.key});

  @override
  State<SqliteIntegrationExample> createState() => _SqliteIntegrationExampleState();
}

class _SqliteIntegrationExampleState extends State<SqliteIntegrationExample> {
  late SqliteHelper _db;
  List<Map<String, dynamic>> _emotionHistories = [];
  List<Map<String, dynamic>> _tasks = [];
  Map<String, int> _stats = {};

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Lấy SqliteHelper từ dependency injection
    _db = di.sl<SqliteHelper>();
    
    // Load dữ liệu ban đầu
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load emotion histories
      final emotions = await _db.getAll(
        DatabaseConstants.emotionHistoriesTable,
        orderBy: '${DatabaseConstants.emotionHistoriesCreatedAt} DESC',
        limit: 10,
      );

      // Load tasks
      final tasks = await _db.getTasksByCompletion(false);

      // Load stats
      final stats = await _getStats();

      setState(() {
        _emotionHistories = emotions;
        _tasks = tasks;
        _stats = stats;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  Future<Map<String, int>> _getStats() async {
    return {
      'total_emotions': await _db.count(DatabaseConstants.emotionHistoriesTable),
      'total_tasks': await _db.count(DatabaseConstants.tasksTable),
      'completed_tasks': await _db.count(
        DatabaseConstants.tasksTable,
        where: '${DatabaseConstants.tasksIsCompleted} = ?',
        whereArgs: [DatabaseConstants.boolTrue],
      ),
      'pending_tasks': await _db.count(
        DatabaseConstants.tasksTable,
        where: '${DatabaseConstants.tasksIsCompleted} = ?',
        whereArgs: [DatabaseConstants.boolFalse],
      ),
    };
  }

  Future<void> _addSampleEmotionHistory() async {
    try {
      await _db.insert(DatabaseConstants.emotionHistoriesTable, {
        DatabaseConstants.emotionHistoriesEmotion: 'Hạnh phúc',
        DatabaseConstants.emotionHistoriesQuote: 'Hạnh phúc không phải là điều gì đó có sẵn.',
        DatabaseConstants.emotionHistoriesAuthor: 'Dalai Lama',
        DatabaseConstants.emotionHistoriesTimestamp: DateTime.now().toIso8601String(),
      });

      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm emotion history mới!')),
        );
      }
    } catch (e) {
      debugPrint('Error adding emotion history: $e');
    }
  }

  Future<void> _addSampleTask() async {
    try {
      final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
      
      await _db.insert(DatabaseConstants.tasksTable, {
        DatabaseConstants.tasksId: taskId,
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
        DatabaseConstants.tasksNotes: 'Tập trung vào hơi thở và cảm nhận hiện tại',
      });

      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm task mới!')),
        );
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  Future<void> _toggleTaskCompletion(String taskId) async {
    try {
      await _db.toggleTaskCompletion(taskId);
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật trạng thái task!')),
        );
      }
    } catch (e) {
      debugPrint('Error toggling task: $e');
    }
  }

  Future<void> _clearAllData() async {
    try {
      await _db.clearAllData();
      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa toàn bộ dữ liệu!')),
        );
      }
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Helper Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thống kê Database',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Tổng emotion histories: ${_stats['total_emotions'] ?? 0}'),
                    Text('Tổng tasks: ${_stats['total_tasks'] ?? 0}'),
                    Text('Tasks hoàn thành: ${_stats['completed_tasks'] ?? 0}'),
                    Text('Tasks chưa hoàn thành: ${_stats['pending_tasks'] ?? 0}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _addSampleEmotionHistory,
                  child: const Text('Thêm Emotion'),
                ),
                ElevatedButton(
                  onPressed: _addSampleTask,
                  child: const Text('Thêm Task'),
                ),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Refresh'),
                ),
                ElevatedButton(
                  onPressed: _clearAllData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Xóa tất cả'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Emotion Histories Section
            const Text(
              'Emotion Histories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._emotionHistories.map((emotion) => Card(
              child: ListTile(
                title: Text(emotion[DatabaseConstants.emotionHistoriesEmotion] ?? ''),
                subtitle: Text(emotion[DatabaseConstants.emotionHistoriesQuote] ?? ''),
                trailing: Text(emotion[DatabaseConstants.emotionHistoriesAuthor] ?? ''),
              ),
            )),
            
            const SizedBox(height: 16),
            
            // Tasks Section
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._tasks.map((task) => Card(
              child: ListTile(
                title: Text(task[DatabaseConstants.tasksTitle] ?? ''),
                subtitle: Text(task[DatabaseConstants.tasksDescription] ?? ''),
                trailing: IconButton(
                  icon: Icon(
                    task[DatabaseConstants.tasksIsCompleted] == DatabaseConstants.boolTrue
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task[DatabaseConstants.tasksIsCompleted] == DatabaseConstants.boolTrue
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () => _toggleTaskCompletion(task[DatabaseConstants.tasksId]),
                ),
                leading: Container(
                  width: 4,
                  height: double.infinity,
                  color: _getPriorityColor(task[DatabaseConstants.tasksPriority] ?? 2),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case DatabaseConstants.taskPriorityLow:
        return Colors.green;
      case DatabaseConstants.taskPriorityMedium:
        return Colors.orange;
      case DatabaseConstants.taskPriorityHigh:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
