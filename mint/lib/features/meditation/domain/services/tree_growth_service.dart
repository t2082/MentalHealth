import 'dart:math' as math;
import '../entities/tree.dart';

/// Service để tính toán cấu trúc cây dựa trên growth và seed
class TreeGrowthService {
  static const double _baseHeight = 200.0;
  static const double _baseTrunkThickness = 8.0;
  static const int _maxBranchLevels = 4;

  /// Tạo cấu trúc cây hoàn chỉnh dựa trên Tree entity
  static TreeStructure generateTreeStructure(Tree tree, double canvasWidth, double canvasHeight) {
    final random = math.Random(tree.seed);
    final centerX = canvasWidth / 2;
    final groundY = canvasHeight * 0.85;
    
    return TreeStructure(
      trunk: _generateTrunk(tree, centerX, groundY, random),
      branches: _generateBranches(tree, centerX, groundY, random),
      leaves: _generateLeaves(tree, centerX, groundY, random),
      flowers: _generateFlowers(tree, centerX, groundY, random),
      fruits: _generateFruits(tree, centerX, groundY, random),
      roots: _generateRoots(tree, centerX, groundY, random),
    );
  }

  /// Tạo thân cây chính
  static TreeBranch _generateTrunk(Tree tree, double centerX, double groundY, math.Random random) {
    if (!tree.hasElement(TreeElement.trunk)) {
      return TreeBranch(
        startX: centerX,
        startY: groundY,
        endX: centerX,
        endY: groundY,
        thickness: 0,
        angle: 0,
        level: 0,
      );
    }

    final trunkHeight = _baseHeight * _getTrunkHeightMultiplier(tree.growth);
    final trunkThickness = _baseTrunkThickness * _getTrunkThicknessMultiplier(tree.growth);
    
    // Thêm một chút nghiêng ngẫu nhiên cho tự nhiên
    final sway = (random.nextDouble() - 0.5) * 10 * (tree.growth / 6.0);
    
    return TreeBranch(
      startX: centerX,
      startY: groundY,
      endX: centerX + sway,
      endY: groundY - trunkHeight,
      thickness: trunkThickness,
      angle: math.pi / 2, // Hướng lên
      level: 0,
    );
  }

  /// Tạo các nhánh cây
  static List<TreeBranch> _generateBranches(Tree tree, double centerX, double groundY, math.Random random) {
    final branches = <TreeBranch>[];
    
    if (!tree.hasElement(TreeElement.primaryBranches)) {
      return branches;
    }

    final trunk = _generateTrunk(tree, centerX, groundY, random);
    final trunkHeight = trunk.endY - trunk.startY;
    
    // Tạo nhánh cấp 1
    final primaryBranchCount = _getPrimaryBranchCount(tree.growth);
    for (int i = 0; i < primaryBranchCount; i++) {
      final branchHeight = trunk.startY + trunkHeight * (0.3 + (i / primaryBranchCount) * 0.6);
      final branch = _createBranch(
        tree,
        trunk.endX,
        branchHeight,
        1,
        random,
        i,
      );
      branches.add(branch);
      
      // Tạo nhánh cấp 2 nếu đủ growth
      if (tree.hasElement(TreeElement.secondaryBranches)) {
        final subBranches = _createSubBranches(tree, branch, random, 2);
        branches.addAll(subBranches);
      }
    }
    
    return branches;
  }

  /// Tạo một nhánh cây
  static TreeBranch _createBranch(
    Tree tree,
    double startX,
    double startY,
    int level,
    math.Random random,
    int index,
  ) {
    final baseLength = _baseHeight * 0.3 / level;
    final length = baseLength * (0.7 + random.nextDouble() * 0.6) * _getBranchLengthMultiplier(tree.growth);
    
    // Góc nhánh: xen kẽ trái phải
    final baseAngle = (index % 2 == 0) ? -math.pi / 4 : math.pi / 4;
    final angleVariation = (random.nextDouble() - 0.5) * math.pi / 6;
    final angle = baseAngle + angleVariation;
    
    final endX = startX + length * math.cos(angle);
    final endY = startY - length * math.sin(angle);
    
    final thickness = _baseTrunkThickness * math.pow(0.6, level) * _getBranchThicknessMultiplier(tree.growth);
    
    return TreeBranch(
      startX: startX,
      startY: startY,
      endX: endX,
      endY: endY,
      thickness: thickness,
      angle: angle,
      level: level,
    );
  }

  /// Tạo nhánh con
  static List<TreeBranch> _createSubBranches(
    Tree tree,
    TreeBranch parentBranch,
    math.Random random,
    int level,
  ) {
    if (level > _maxBranchLevels || tree.growth < level + 1.0) {
      return [];
    }
    
    final subBranches = <TreeBranch>[];
    final subBranchCount = math.max(1, (3 - level) * (tree.growth / 6.0)).round();
    
    for (int i = 0; i < subBranchCount; i++) {
      final t = (i + 1) / (subBranchCount + 1);
      final branchX = parentBranch.startX + (parentBranch.endX - parentBranch.startX) * t;
      final branchY = parentBranch.startY + (parentBranch.endY - parentBranch.startY) * t;
      
      final subBranch = _createBranch(tree, branchX, branchY, level, random, i);
      subBranches.add(subBranch);
      
      // Đệ quy tạo nhánh cấp tiếp theo
      if (level < _maxBranchLevels) {
        final nextLevelBranches = _createSubBranches(tree, subBranch, random, level + 1);
        subBranches.addAll(nextLevelBranches);
      }
    }
    
    return subBranches;
  }

  /// Tạo lá cây
  static List<TreeLeaf> _generateLeaves(Tree tree, double centerX, double groundY, math.Random random) {
    final leaves = <TreeLeaf>[];
    
    if (!tree.hasElement(TreeElement.firstLeaves)) {
      return leaves;
    }

    final branches = _generateBranches(tree, centerX, groundY, random);
    final leafDensity = _getLeafDensity(tree.growth);
    
    for (final branch in branches) {
      final leavesOnBranch = (branch.length * leafDensity / 20).round();
      
      for (int i = 0; i < leavesOnBranch; i++) {
        final t = random.nextDouble();
        final leafX = branch.startX + (branch.endX - branch.startX) * t;
        final leafY = branch.startY + (branch.endY - branch.startY) * t;
        
        // Offset lá ra khỏi nhánh một chút
        final offsetDistance = 5 + random.nextDouble() * 10;
        final offsetAngle = random.nextDouble() * 2 * math.pi;
        final finalX = leafX + offsetDistance * math.cos(offsetAngle);
        final finalY = leafY + offsetDistance * math.sin(offsetAngle);
        
        leaves.add(TreeLeaf(
          x: finalX,
          y: finalY,
          size: 3 + random.nextDouble() * 4,
          rotation: random.nextDouble() * 2 * math.pi,
          type: _getLeafType(tree.growth, random),
        ));
      }
    }
    
    return leaves;
  }

  /// Tạo hoa
  static List<TreeFlower> _generateFlowers(Tree tree, double centerX, double groundY, math.Random random) {
    final flowers = <TreeFlower>[];
    
    if (!tree.hasElement(TreeElement.flowers)) {
      return flowers;
    }

    final branches = _generateBranches(tree, centerX, groundY, random);
    final flowerCount = (tree.growth - 4.0) * 5; // Tăng dần từ growth 5.0
    
    for (int i = 0; i < flowerCount.round(); i++) {
      if (branches.isNotEmpty) {
        final branch = branches[random.nextInt(branches.length)];
        final t = 0.7 + random.nextDouble() * 0.3; // Hoa ở đầu nhánh
        
        final flowerX = branch.startX + (branch.endX - branch.startX) * t;
        final flowerY = branch.startY + (branch.endY - branch.startY) * t;
        
        flowers.add(TreeFlower(
          x: flowerX,
          y: flowerY,
          size: 4 + random.nextDouble() * 3,
          type: _getFlowerType(tree.growth, random),
        ));
      }
    }
    
    return flowers;
  }

  /// Tạo quả
  static List<TreeFruit> _generateFruits(Tree tree, double centerX, double groundY, math.Random random) {
    final fruits = <TreeFruit>[];
    
    if (!tree.hasElement(TreeElement.fruits)) {
      return fruits;
    }

    final branches = _generateBranches(tree, centerX, groundY, random);
    final fruitCount = (tree.growth - 5.0) * 3; // Tăng dần từ growth 6.0
    
    for (int i = 0; i < fruitCount.round(); i++) {
      if (branches.isNotEmpty) {
        final branch = branches[random.nextInt(branches.length)];
        final t = 0.5 + random.nextDouble() * 0.4;
        
        final fruitX = branch.startX + (branch.endX - branch.startX) * t;
        final fruitY = branch.startY + (branch.endY - branch.startY) * t;
        
        fruits.add(TreeFruit(
          x: fruitX,
          y: fruitY,
          size: 5 + random.nextDouble() * 4,
          type: _getFruitType(tree.growth, random),
        ));
      }
    }
    
    return fruits;
  }

  /// Tạo rễ cây
  static List<TreeBranch> _generateRoots(Tree tree, double centerX, double groundY, math.Random random) {
    final roots = <TreeBranch>[];
    
    if (!tree.hasElement(TreeElement.roots)) {
      return roots;
    }

    final rootCount = 3 + (tree.growth * 2).round();
    final rootLength = 30 + tree.growth * 10;
    
    for (int i = 0; i < rootCount; i++) {
      final angle = (i / rootCount) * 2 * math.pi + (random.nextDouble() - 0.5) * 0.5;
      final length = rootLength * (0.7 + random.nextDouble() * 0.6);
      
      final endX = centerX + length * math.cos(angle);
      final endY = groundY + length * math.sin(angle) * 0.3; // Rễ nông hơn
      
      roots.add(TreeBranch(
        startX: centerX,
        startY: groundY,
        endX: endX,
        endY: endY,
        thickness: 2 + tree.growth,
        angle: angle,
        level: -1, // Rễ có level âm
      ));
    }
    
    return roots;
  }

  // Helper methods để tính toán multipliers
  static double _getTrunkHeightMultiplier(double growth) {
    return math.min(1.0, growth / 3.0);
  }

  static double _getTrunkThicknessMultiplier(double growth) {
    return math.min(1.0, growth / 4.0);
  }

  static double _getBranchLengthMultiplier(double growth) {
    return math.min(1.0, (growth - 2.0) / 2.0);
  }

  static double _getBranchThicknessMultiplier(double growth) {
    return math.min(1.0, (growth - 2.0) / 3.0);
  }

  static int _getPrimaryBranchCount(double growth) {
    if (growth < 3.0) return 0;
    return math.min(6, ((growth - 2.0) * 2).round());
  }

  static double _getLeafDensity(double growth) {
    if (growth < 2.0) return 0;
    return math.min(1.0, (growth - 1.0) / 3.0);
  }

  static TreeLeafType _getLeafType(double growth, math.Random random) {
    if (growth < 3.0) return TreeLeafType.small;
    if (growth < 4.5) return random.nextBool() ? TreeLeafType.small : TreeLeafType.medium;
    final rand = random.nextDouble();
    if (rand < 0.3) return TreeLeafType.small;
    if (rand < 0.7) return TreeLeafType.medium;
    return TreeLeafType.large;
  }

  static TreeFlowerType _getFlowerType(double growth, math.Random random) {
    if (growth < 5.2) return TreeFlowerType.bud;
    if (growth < 5.7) return random.nextBool() ? TreeFlowerType.bud : TreeFlowerType.blooming;
    final rand = random.nextDouble();
    if (rand < 0.2) return TreeFlowerType.bud;
    if (rand < 0.6) return TreeFlowerType.blooming;
    return TreeFlowerType.fullBloom;
  }

  static TreeFruitType _getFruitType(double growth, math.Random random) {
    if (growth < 6.3) return TreeFruitType.small;
    if (growth < 6.7) return random.nextBool() ? TreeFruitType.small : TreeFruitType.medium;
    final rand = random.nextDouble();
    if (rand < 0.3) return TreeFruitType.small;
    if (rand < 0.7) return TreeFruitType.medium;
    return TreeFruitType.ripe;
  }
}

/// Cấu trúc hoàn chỉnh của cây
class TreeStructure {
  final TreeBranch trunk;
  final List<TreeBranch> branches;
  final List<TreeLeaf> leaves;
  final List<TreeFlower> flowers;
  final List<TreeFruit> fruits;
  final List<TreeBranch> roots;

  const TreeStructure({
    required this.trunk,
    required this.branches,
    required this.leaves,
    required this.flowers,
    required this.fruits,
    required this.roots,
  });
}
