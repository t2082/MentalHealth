import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';

/// Model cho Task để serialize/deserialize
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    super.isCompleted,
    required super.createdAt,
    super.completedAt,
    super.priority,
    super.dueDate,
    super.tags,
    super.estimatedMinutes,
    super.notes,
  });

  /// Tạo TaskModel từ Task entity
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
      priority: task.priority,
      dueDate: task.dueDate,
      tags: task.tags,
      estimatedMinutes: task.estimatedMinutes,
      notes: task.notes,
    );
  }

  /// Tạo TaskModel từ JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: TaskCategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      priority: json['priority'] as int? ?? 2,
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 30,
      notes: json['notes'] as String?,
    );
  }

  /// Chuyển TaskModel thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': TaskCategoryModel.fromEntity(category).toJson(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'tags': tags,
      'estimatedMinutes': estimatedMinutes,
      'notes': notes,
    };
  }

  /// Chuyển thành Task entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      category: category,
      isCompleted: isCompleted,
      createdAt: createdAt,
      completedAt: completedAt,
      priority: priority,
      dueDate: dueDate,
      tags: tags,
      estimatedMinutes: estimatedMinutes,
      notes: notes,
    );
  }

  /// Tạo bản sao với các thuộc tính được cập nhật
  @override
  TaskModel copyWith({
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
    return TaskModel(
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
}

/// Model cho TaskCategory
class TaskCategoryModel extends TaskCategory {
  const TaskCategoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconName,
    required super.colorHex,
    super.isActive,
  });

  /// Tạo TaskCategoryModel từ TaskCategory entity
  factory TaskCategoryModel.fromEntity(TaskCategory category) {
    return TaskCategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      iconName: category.iconName,
      colorHex: category.colorHex,
      isActive: category.isActive,
    );
  }

  /// Tạo TaskCategoryModel từ JSON
  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) {
    return TaskCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Chuyển TaskCategoryModel thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'colorHex': colorHex,
      'isActive': isActive,
    };
  }

  /// Chuyển thành TaskCategory entity
  TaskCategory toEntity() {
    return TaskCategory(
      id: id,
      name: name,
      description: description,
      iconName: iconName,
      colorHex: colorHex,
      isActive: isActive,
    );
  }
}
