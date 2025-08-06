import 'dart:math' as math;

/// Entity đại diện cho một cây trong vườn tâm hồn
class Tree {
  final String id;
  final double growth; // 0.0 - 6.0+
  final int seed; // Seed để tạo cấu trúc ngẫu nhiên nhất quán
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String? name; // Tên cây (tùy chọn)

  const Tree({
    required this.id,
    required this.growth,
    required this.seed,
    required this.createdAt,
    required this.lastUpdated,
    this.name,
  });

  /// Tạo cây mới với seed ngẫu nhiên
  factory Tree.create({
    required String id,
    double growth = 0.0,
    String? name,
  }) {
    final now = DateTime.now();
    return Tree(
      id: id,
      growth: growth,
      seed: math.Random().nextInt(1000000),
      createdAt: now,
      lastUpdated: now,
      name: name,
    );
  }

  /// Copy với các thay đổi
  Tree copyWith({
    String? id,
    double? growth,
    int? seed,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? name,
  }) {
    return Tree(
      id: id ?? this.id,
      growth: growth ?? this.growth,
      seed: seed ?? this.seed,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      name: name ?? this.name,
    );
  }

  /// Cập nhật growth và lastUpdated
  Tree updateGrowth(double newGrowth) {
    return copyWith(
      growth: newGrowth,
      lastUpdated: DateTime.now(),
    );
  }

  /// Lấy giai đoạn phát triển hiện tại
  TreeGrowthStage get currentStage {
    if (growth < 1.0) return TreeGrowthStage.seed;
    if (growth < 2.0) return TreeGrowthStage.sprout;
    if (growth < 3.0) return TreeGrowthStage.sapling;
    if (growth < 4.0) return TreeGrowthStage.youngTree;
    if (growth < 5.0) return TreeGrowthStage.matureTree;
    if (growth < 6.0) return TreeGrowthStage.flowering;
    return TreeGrowthStage.fruiting;
  }

  /// Kiểm tra xem có phần tử nào hiển thị không
  bool hasElement(TreeElement element) {
    switch (element) {
      case TreeElement.seed:
        return growth >= 0.0;
      case TreeElement.roots:
        return growth >= 1.0;
      case TreeElement.trunk:
        return growth >= 1.5;
      case TreeElement.firstLeaves:
        return growth >= 2.0;
      case TreeElement.primaryBranches:
        return growth >= 3.0;
      case TreeElement.secondaryBranches:
        return growth >= 3.5;
      case TreeElement.moreLeaves:
        return growth >= 4.0;
      case TreeElement.flowers:
        return growth >= 5.0;
      case TreeElement.fruits:
        return growth >= 6.0;
    }
  }

  @override
  String toString() {
    return 'Tree(id: $id, growth: $growth, seed: $seed, stage: ${currentStage.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tree &&
        other.id == id &&
        other.growth == growth &&
        other.seed == seed;
  }

  @override
  int get hashCode {
    return id.hashCode ^ growth.hashCode ^ seed.hashCode;
  }
}

/// Các giai đoạn phát triển của cây
enum TreeGrowthStage {
  seed('Hạt giống', 'Hạt mầm chưa nảy'),
  sprout('Mầm non', 'Mầm bắt đầu nhú, rễ nhỏ'),
  sapling('Cây con', 'Thân cây con và 2 lá mầm'),
  youngTree('Cây trẻ', 'Cây lớn hơn, có cành cấp 1'),
  matureTree('Cây trưởng thành', 'Có nhiều cành và lá'),
  flowering('Ra hoa', 'Cây ra hoa'),
  fruiting('Có quả', 'Có quả, tiếp tục phân nhánh');

  const TreeGrowthStage(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Các phần tử của cây
enum TreeElement {
  seed,
  roots,
  trunk,
  firstLeaves,
  primaryBranches,
  secondaryBranches,
  moreLeaves,
  flowers,
  fruits,
}

/// Cấu trúc dữ liệu cho một nhánh cây
class TreeBranch {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double thickness;
  final double angle;
  final int level; // Cấp nhánh (0 = thân chính, 1 = nhánh cấp 1, ...)
  final List<TreeBranch> subBranches;
  final List<TreeLeaf> leaves;

  const TreeBranch({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.thickness,
    required this.angle,
    required this.level,
    this.subBranches = const [],
    this.leaves = const [],
  });

  TreeBranch copyWith({
    double? startX,
    double? startY,
    double? endX,
    double? endY,
    double? thickness,
    double? angle,
    int? level,
    List<TreeBranch>? subBranches,
    List<TreeLeaf>? leaves,
  }) {
    return TreeBranch(
      startX: startX ?? this.startX,
      startY: startY ?? this.startY,
      endX: endX ?? this.endX,
      endY: endY ?? this.endY,
      thickness: thickness ?? this.thickness,
      angle: angle ?? this.angle,
      level: level ?? this.level,
      subBranches: subBranches ?? this.subBranches,
      leaves: leaves ?? this.leaves,
    );
  }

  double get length =>
      math.sqrt(math.pow(endX - startX, 2) + math.pow(endY - startY, 2));
}

/// Cấu trúc dữ liệu cho một lá cây
class TreeLeaf {
  final double x;
  final double y;
  final double size;
  final double rotation;
  final TreeLeafType type;

  const TreeLeaf({
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.type,
  });
}

/// Các loại lá
enum TreeLeafType {
  small,
  medium,
  large,
}

/// Cấu trúc dữ liệu cho hoa
class TreeFlower {
  final double x;
  final double y;
  final double size;
  final TreeFlowerType type;

  const TreeFlower({
    required this.x,
    required this.y,
    required this.size,
    required this.type,
  });
}

/// Các loại hoa
enum TreeFlowerType {
  bud,
  blooming,
  fullBloom,
}

/// Cấu trúc dữ liệu cho quả
class TreeFruit {
  final double x;
  final double y;
  final double size;
  final TreeFruitType type;

  const TreeFruit({
    required this.x,
    required this.y,
    required this.size,
    required this.type,
  });
}

/// Các loại quả
enum TreeFruitType {
  small,
  medium,
  ripe,
}
