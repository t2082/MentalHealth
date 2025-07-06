import 'package:equatable/equatable.dart';
import 'task_category.dart';

/// Entity đại diện cho một nhiệm vụ
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int priority; // 1: Thấp, 2: Trung bình, 3: Cao
  final DateTime? dueDate;
  final List<String> tags;
  final int estimatedMinutes;
  final String? notes;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.priority = 2,
    this.dueDate,
    this.tags = const [],
    this.estimatedMinutes = 30,
    this.notes,
  });

  /// Tạo bản sao với các thuộc tính được cập nhật
  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    int? priority,
    DateTime? dueDate,
    List<String>? tags,
    int? estimatedMinutes,
    String? notes,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      notes: notes ?? this.notes,
    );
  }

  /// Đánh dấu nhiệm vụ hoàn thành
  Task markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  /// Đánh dấu nhiệm vụ chưa hoàn thành
  Task markAsIncomplete() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  /// Kiểm tra xem nhiệm vụ có quá hạn không
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Kiểm tra xem nhiệm vụ có sắp đến hạn không (trong 24h)
  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return dueDate!.isBefore(tomorrow) && dueDate!.isAfter(now);
  }

  /// Lấy màu ưu tiên
  String get priorityColor {
    switch (priority) {
      case 1:
        return '#4CAF50'; // Xanh lá - Thấp
      case 2:
        return '#FF9800'; // Cam - Trung bình
      case 3:
        return '#F44336'; // Đỏ - Cao
      default:
        return '#9E9E9E'; // Xám - Mặc định
    }
  }

  /// Lấy text ưu tiên
  String get priorityText {
    switch (priority) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      case 3:
        return 'Cao';
      default:
        return 'Không xác định';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        isCompleted,
        createdAt,
        completedAt,
        priority,
        dueDate,
        tags,
        estimatedMinutes,
        notes,
      ];
}
