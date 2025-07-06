import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity đại diện cho danh mục nhiệm vụ
class TaskCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String colorHex;
  final bool isActive;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.colorHex,
    this.isActive = true,
  });

  /// Lấy màu từ hex string
  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  /// Lấy icon từ tên
  IconData get icon {
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'favorite':
        return Icons.favorite;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'school':
        return Icons.school;
      case 'people':
        return Icons.people;
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.task_alt;
    }
  }

  /// Tạo bản sao với các thuộc tính được cập nhật
  TaskCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? colorHex,
    bool? isActive,
  }) {
    return TaskCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconName, colorHex, isActive];

  /// Danh mục mặc định
  static const List<TaskCategory> defaultCategories = [
    TaskCategory(
      id: 'spiritual',
      name: 'Tâm linh',
      description: 'Thiền, yoga, tâm linh',
      iconName: 'psychology',
      colorHex: '#9C27B0',
    ),
    TaskCategory(
      id: 'emotional',
      name: 'Cảm xúc',
      description: 'Quản lý cảm xúc, nhật ký',
      iconName: 'favorite',
      colorHex: '#E91E63',
    ),
    TaskCategory(
      id: 'physical',
      name: 'Thể chất',
      description: 'Tập thể dục, sức khỏe',
      iconName: 'fitness_center',
      colorHex: '#4CAF50',
    ),
    TaskCategory(
      id: 'learning',
      name: 'Học tập',
      description: 'Đọc sách, học hỏi',
      iconName: 'school',
      colorHex: '#2196F3',
    ),
    TaskCategory(
      id: 'social',
      name: 'Xã hội',
      description: 'Kết nối, giao tiếp',
      iconName: 'people',
      colorHex: '#FF9800',
    ),
    TaskCategory(
      id: 'work',
      name: 'Công việc',
      description: 'Nhiệm vụ công việc',
      iconName: 'work',
      colorHex: '#607D8B',
    ),
    TaskCategory(
      id: 'personal',
      name: 'Cá nhân',
      description: 'Việc cá nhân, gia đình',
      iconName: 'home',
      colorHex: '#795548',
    ),
    TaskCategory(
      id: 'health',
      name: 'Sức khỏe',
      description: 'Chăm sóc sức khỏe',
      iconName: 'local_hospital',
      colorHex: '#F44336',
    ),
  ];
}
