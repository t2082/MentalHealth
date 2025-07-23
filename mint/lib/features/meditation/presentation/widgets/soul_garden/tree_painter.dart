import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../domain/entities/tree.dart';
import '../../../domain/services/tree_growth_service.dart';

/// CustomPainter để vẽ cây với các giai đoạn phát triển khác nhau
class TreePainter extends CustomPainter {
  final Tree tree;
  final Color trunkColor;
  final Color leafColor;
  final Color flowerColor;
  final Color fruitColor;
  final Color rootColor;

  TreePainter({
    required this.tree,
    this.trunkColor = const Color(0xFF8B4513),
    this.leafColor = const Color(0xFF228B22),
    this.flowerColor = const Color(0xFFFFB6C1),
    this.fruitColor = const Color(0xFFFF6347),
    this.rootColor = const Color(0xFF654321),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Tạo cấu trúc cây dựa trên growth và seed
    final treeStructure = TreeGrowthService.generateTreeStructure(
      tree,
      size.width,
      size.height,
    );

    // Vẽ theo thứ tự: rễ -> thân -> nhánh -> lá -> hoa -> quả
    _drawRoots(canvas, treeStructure.roots);
    _drawSeed(canvas, size);
    _drawTrunk(canvas, treeStructure.trunk);
    _drawBranches(canvas, treeStructure.branches);
    _drawLeaves(canvas, treeStructure.leaves);
    _drawFlowers(canvas, treeStructure.flowers);
    _drawFruits(canvas, treeStructure.fruits);
  }

  /// Vẽ hạt giống
  void _drawSeed(Canvas canvas, Size size) {
    if (tree.growth > 1.0) return; // Chỉ hiển thị khi còn là hạt giống

    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final groundY = size.height * 0.85;

    if (tree.growth < 0.5) {
      // Hạt giống chưa nảy
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, groundY + 5),
          width: 8,
          height: 6,
        ),
        paint,
      );
    } else {
      // Hạt giống bắt đầu nảy mầm
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, groundY + 3),
          width: 6,
          height: 4,
        ),
        paint,
      );

      // Mầm nhỏ
      final sproutPaint = Paint()
        ..color = const Color(0xFF90EE90)
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, groundY - 5),
          width: 3,
          height: 8,
        ),
        sproutPaint,
      );
    }
  }

  /// Vẽ rễ cây
  void _drawRoots(Canvas canvas, List<TreeBranch> roots) {
    if (roots.isEmpty) return;

    final paint = Paint()
      ..color = rootColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final root in roots) {
      paint.strokeWidth = root.thickness;
      canvas.drawLine(
        Offset(root.startX, root.startY),
        Offset(root.endX, root.endY),
        paint,
      );
    }
  }

  /// Vẽ thân cây
  void _drawTrunk(Canvas canvas, TreeBranch trunk) {
    if (trunk.thickness <= 0) return;

    final paint = Paint()
      ..color = trunkColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = trunk.thickness;

    canvas.drawLine(
      Offset(trunk.startX, trunk.startY),
      Offset(trunk.endX, trunk.endY),
      paint,
    );

    // Vẽ texture thân cây
    _drawTrunkTexture(canvas, trunk);
  }

  /// Vẽ texture cho thân cây
  void _drawTrunkTexture(Canvas canvas, TreeBranch trunk) {
    if (trunk.thickness < 5) return;

    final texturePaint = Paint()
      ..color = trunkColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final random = math.Random(tree.seed);
    final lineCount = (trunk.length / 20).round();

    for (int i = 0; i < lineCount; i++) {
      final t = i / lineCount;
      final x = trunk.startX + (trunk.endX - trunk.startX) * t;
      final y = trunk.startY + (trunk.endY - trunk.startY) * t;

      final offset = (random.nextDouble() - 0.5) * trunk.thickness * 0.3;
      canvas.drawLine(
        Offset(x - offset, y),
        Offset(x + offset, y),
        texturePaint,
      );
    }
  }

  /// Vẽ các nhánh cây
  void _drawBranches(Canvas canvas, List<TreeBranch> branches) {
    if (branches.isEmpty) return;

    final paint = Paint()
      ..color = trunkColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final branch in branches) {
      paint.strokeWidth = branch.thickness;
      canvas.drawLine(
        Offset(branch.startX, branch.startY),
        Offset(branch.endX, branch.endY),
        paint,
      );
    }
  }

  /// Vẽ lá cây
  void _drawLeaves(Canvas canvas, List<TreeLeaf> leaves) {
    if (leaves.isEmpty) return;

    for (final leaf in leaves) {
      _drawLeaf(canvas, leaf);
    }
  }

  /// Vẽ một lá cây
  void _drawLeaf(Canvas canvas, TreeLeaf leaf) {
    final paint = Paint()
      ..color = _getLeafColor(leaf.type)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(leaf.x, leaf.y);
    canvas.rotate(leaf.rotation);

    final path = Path();
    final size = leaf.size;

    // Vẽ hình lá đơn giản
    path.moveTo(0, -size);
    path.quadraticBezierTo(size * 0.7, -size * 0.3, size * 0.5, 0);
    path.quadraticBezierTo(size * 0.3, size * 0.7, 0, size);
    path.quadraticBezierTo(-size * 0.3, size * 0.7, -size * 0.5, 0);
    path.quadraticBezierTo(-size * 0.7, -size * 0.3, 0, -size);

    canvas.drawPath(path, paint);

    // Vẽ gân lá
    final veinPaint = Paint()
      ..color = _getLeafColor(leaf.type).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawLine(
      Offset(0, -size),
      Offset(0, size),
      veinPaint,
    );

    canvas.restore();
  }

  /// Vẽ hoa
  void _drawFlowers(Canvas canvas, List<TreeFlower> flowers) {
    if (flowers.isEmpty) return;

    for (final flower in flowers) {
      _drawFlower(canvas, flower);
    }
  }

  /// Vẽ một bông hoa
  void _drawFlower(Canvas canvas, TreeFlower flower) {
    final paint = Paint()
      ..color = _getFlowerColor(flower.type)
      ..style = PaintingStyle.fill;

    final centerPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final petalCount = 5;
    final petalSize = flower.size;

    canvas.save();
    canvas.translate(flower.x, flower.y);

    // Vẽ cánh hoa
    for (int i = 0; i < petalCount; i++) {
      canvas.save();
      canvas.rotate((i * 2 * math.pi) / petalCount);

      final path = Path();
      path.addOval(Rect.fromCenter(
        center: Offset(0, -petalSize * 0.6),
        width: petalSize * 0.6,
        height: petalSize,
      ));

      canvas.drawPath(path, paint);
      canvas.restore();
    }

    // Vẽ nhụy hoa
    canvas.drawCircle(
      Offset.zero,
      petalSize * 0.2,
      centerPaint,
    );

    canvas.restore();
  }

  /// Vẽ quả
  void _drawFruits(Canvas canvas, List<TreeFruit> fruits) {
    if (fruits.isEmpty) return;

    for (final fruit in fruits) {
      _drawFruit(canvas, fruit);
    }
  }

  /// Vẽ một quả
  void _drawFruit(Canvas canvas, TreeFruit fruit) {
    final paint = Paint()
      ..color = _getFruitColor(fruit.type)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = _getFruitColor(fruit.type).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    // Vẽ quả hình tròn
    canvas.drawCircle(
      Offset(fruit.x, fruit.y),
      fruit.size,
      paint,
    );

    // Vẽ highlight
    canvas.drawCircle(
      Offset(fruit.x - fruit.size * 0.3, fruit.y - fruit.size * 0.3),
      fruit.size * 0.3,
      highlightPaint,
    );
  }

  /// Lấy màu lá theo loại
  Color _getLeafColor(TreeLeafType type) {
    switch (type) {
      case TreeLeafType.small:
        return leafColor.withOpacity(0.8);
      case TreeLeafType.medium:
        return leafColor;
      case TreeLeafType.large:
        return leafColor.withOpacity(0.9);
    }
  }

  /// Lấy màu hoa theo loại
  Color _getFlowerColor(TreeFlowerType type) {
    switch (type) {
      case TreeFlowerType.bud:
        return flowerColor.withOpacity(0.6);
      case TreeFlowerType.blooming:
        return flowerColor.withOpacity(0.8);
      case TreeFlowerType.fullBloom:
        return flowerColor;
    }
  }

  /// Lấy màu quả theo loại
  Color _getFruitColor(TreeFruitType type) {
    switch (type) {
      case TreeFruitType.small:
        return fruitColor.withOpacity(0.6);
      case TreeFruitType.medium:
        return fruitColor.withOpacity(0.8);
      case TreeFruitType.ripe:
        return fruitColor;
    }
  }

  @override
  bool shouldRepaint(covariant TreePainter oldDelegate) {
    return oldDelegate.tree != tree ||
        oldDelegate.trunkColor != trunkColor ||
        oldDelegate.leafColor != leafColor ||
        oldDelegate.flowerColor != flowerColor ||
        oldDelegate.fruitColor != fruitColor ||
        oldDelegate.rootColor != rootColor;
  }
}
