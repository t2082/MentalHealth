import 'package:mental_health/features/meditation/domain/entities/tree.dart';

/// Model cho Tree để serialize/deserialize với database
class TreeModel extends Tree {
  const TreeModel({
    required super.id,
    required super.growth,
    required super.seed,
    required super.createdAt,
    required super.lastUpdated,
    super.name,
  });

  /// Tạo TreeModel từ Tree entity
  factory TreeModel.fromEntity(Tree tree) {
    return TreeModel(
      id: tree.id,
      growth: tree.growth,
      seed: tree.seed,
      createdAt: tree.createdAt,
      lastUpdated: tree.lastUpdated,
      name: tree.name,
    );
  }

  /// Tạo TreeModel từ JSON
  factory TreeModel.fromJson(Map<String, dynamic> json) {
    return TreeModel(
      id: json['id'] as String,
      growth: (json['growth'] as num).toDouble(),
      seed: json['seed'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      name: json['name'] as String?,
    );
  }

  /// Chuyển TreeModel thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'growth': growth,
      'seed': seed,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'name': name,
    };
  }

  /// Chuyển thành Tree entity
  Tree toEntity() {
    return Tree(
      id: id,
      growth: growth,
      seed: seed,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
      name: name,
    );
  }

  /// Tạo TreeModel mới với các thay đổi
  TreeModel copyWith({
    String? id,
    double? growth,
    int? seed,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? name,
  }) {
    return TreeModel(
      id: id ?? this.id,
      growth: growth ?? this.growth,
      seed: seed ?? this.seed,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      name: name ?? this.name,
    );
  }

  /// Cập nhật growth
  TreeModel updateGrowth(double newGrowth) {
    return copyWith(
      growth: newGrowth,
      lastUpdated: DateTime.now(),
    );
  }
}
