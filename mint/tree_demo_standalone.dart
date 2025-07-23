import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const TreeDemoApp());
}

class TreeDemoApp extends StatelessWidget {
  const TreeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Growth Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const TreeDemoScreen(),
    );
  }
}

class TreeDemoScreen extends StatefulWidget {
  const TreeDemoScreen({super.key});

  @override
  State<TreeDemoScreen> createState() => _TreeDemoScreenState();
}

class _TreeDemoScreenState extends State<TreeDemoScreen> {
  double _growth = 0.0;
  late Tree _demoTree;

  @override
  void initState() {
    super.initState();
    _demoTree = Tree.create(
      id: 'demo_tree',
      growth: _growth,
      name: 'Cây Demo',
    );
  }

  void _updateGrowth(double newGrowth) {
    setState(() {
      _growth = newGrowth;
      _demoTree = _demoTree.updateGrowth(newGrowth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Growth Demo'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          // Growth Control
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Tree Growth: ${_growth.toStringAsFixed(1)} / 6.0 (${_demoTree.currentStage.displayName})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: _growth,
                  min: 0.0,
                  max: 6.0,
                  divisions: 60,
                  onChanged: _updateGrowth,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateGrowth(0.0),
                      child: const Text('Hạt giống'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(1.0),
                      child: const Text('Mầm non'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(2.0),
                      child: const Text('Cây con'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(3.0),
                      child: const Text('Cây trẻ'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(4.0),
                      child: const Text('Cây lớn'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(5.0),
                      child: const Text('Ra hoa'),
                    ),
                    ElevatedButton(
                      onPressed: () => _updateGrowth(6.0),
                      child: const Text('Có quả'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tree Display
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Center(
                child: TreeWidget.fromTree(
                  _demoTree,
                  size: 300,
                  trunkColor: const Color(0xFF8B4513),
                  leafColor: Colors.green.shade600,
                ),
              ),
            ),
          ),

          // Growth Stages Info
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Các giai đoạn phát triển:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                _buildStageInfo('0.0 - 0.9', 'Hạt giống chưa nảy'),
                _buildStageInfo('1.0 - 1.9', 'Mầm bắt đầu nhú, rễ nhỏ'),
                _buildStageInfo('2.0 - 2.9', 'Thân cây con và 2 lá mầm'),
                _buildStageInfo('3.0 - 3.9', 'Cây lớn hơn, có cành cấp 1'),
                _buildStageInfo('4.0 - 4.9', 'Có nhiều cành và lá'),
                _buildStageInfo('5.0 - 5.9', 'Ra hoa'),
                _buildStageInfo('6.0+', 'Có quả, tiếp tục phân nhánh'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageInfo(String range, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              range,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const Text(' - '),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }
}

// Simplified Tree classes for standalone demo
class Tree {
  final String id;
  final double growth;
  final int seed;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String? name;

  const Tree({
    required this.id,
    required this.growth,
    required this.seed,
    required this.createdAt,
    required this.lastUpdated,
    this.name,
  });

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

  Tree updateGrowth(double newGrowth) {
    return Tree(
      id: id,
      growth: newGrowth,
      seed: seed,
      createdAt: createdAt,
      lastUpdated: DateTime.now(),
      name: name,
    );
  }

  TreeGrowthStage get currentStage {
    if (growth < 1.0) return TreeGrowthStage.seed;
    if (growth < 2.0) return TreeGrowthStage.sprout;
    if (growth < 3.0) return TreeGrowthStage.sapling;
    if (growth < 4.0) return TreeGrowthStage.youngTree;
    if (growth < 5.0) return TreeGrowthStage.matureTree;
    if (growth < 6.0) return TreeGrowthStage.flowering;
    return TreeGrowthStage.fruiting;
  }
}

enum TreeGrowthStage {
  seed('Hạt giống'),
  sprout('Mầm non'),
  sapling('Cây con'),
  youngTree('Cây trẻ'),
  matureTree('Cây trưởng thành'),
  flowering('Ra hoa'),
  fruiting('Có quả');

  const TreeGrowthStage(this.displayName);
  final String displayName;
}

class TreeWidget extends StatelessWidget {
  final Tree tree;
  final double size;
  final Color? trunkColor;
  final Color? leafColor;

  const TreeWidget.fromTree(
    this.tree, {
    super.key,
    this.size = 200,
    this.trunkColor,
    this.leafColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SimpleTreePainter(
          tree: tree,
          trunkColor: trunkColor ?? const Color(0xFF8B4513),
          leafColor: leafColor ?? const Color(0xFF228B22),
        ),
      ),
    );
  }
}

class SimpleTreePainter extends CustomPainter {
  final Tree tree;
  final Color trunkColor;
  final Color leafColor;

  SimpleTreePainter({
    required this.tree,
    required this.trunkColor,
    required this.leafColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final groundY = size.height * 0.85;
    final random = math.Random(tree.seed);

    // Draw based on growth stage
    if (tree.growth < 1.0) {
      _drawSeed(canvas, centerX, groundY);
    } else {
      _drawTree(canvas, size, centerX, groundY, random);
    }
  }

  void _drawSeed(Canvas canvas, double centerX, double groundY) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    if (tree.growth < 0.5) {
      // Seed
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, groundY + 5),
          width: 8,
          height: 6,
        ),
        paint,
      );
    } else {
      // Sprouting seed
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, groundY + 3),
          width: 6,
          height: 4,
        ),
        paint,
      );

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

  void _drawTree(Canvas canvas, Size size, double centerX, double groundY,
      math.Random random) {
    final trunkHeight = 100.0 * math.min(1.0, tree.growth / 3.0);
    final trunkThickness = 8.0 * math.min(1.0, tree.growth / 4.0);

    // Draw trunk
    final trunkPaint = Paint()
      ..color = trunkColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = trunkThickness;

    canvas.drawLine(
      Offset(centerX, groundY),
      Offset(centerX, groundY - trunkHeight),
      trunkPaint,
    );

    // Draw branches if growth >= 3.0
    if (tree.growth >= 3.0) {
      _drawBranches(canvas, centerX, groundY - trunkHeight, random);
    }

    // Draw leaves if growth >= 2.0
    if (tree.growth >= 2.0) {
      _drawLeaves(canvas, centerX, groundY - trunkHeight, random);
    }

    // Draw flowers if growth >= 5.0
    if (tree.growth >= 5.0) {
      _drawFlowers(canvas, centerX, groundY - trunkHeight, random);
    }

    // Draw fruits if growth >= 6.0
    if (tree.growth >= 6.0) {
      _drawFruits(canvas, centerX, groundY - trunkHeight, random);
    }
  }

  void _drawBranches(
      Canvas canvas, double centerX, double topY, math.Random random) {
    final branchPaint = Paint()
      ..color = trunkColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final branchCount = ((tree.growth - 2.0) * 3).round().clamp(1, 6);

    for (int i = 0; i < branchCount; i++) {
      final angle = (i % 2 == 0) ? -math.pi / 4 : math.pi / 4;
      final length = 30 + random.nextDouble() * 20;
      final thickness = 3 + (tree.growth - 3.0) * 2;

      branchPaint.strokeWidth = thickness;

      final endX = centerX + length * math.cos(angle);
      final endY = topY - length * math.sin(angle);

      canvas.drawLine(
        Offset(centerX, topY - i * 10),
        Offset(endX, endY),
        branchPaint,
      );
    }
  }

  void _drawLeaves(
      Canvas canvas, double centerX, double topY, math.Random random) {
    final leafPaint = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    final leafCount = (tree.growth * 10).round();

    for (int i = 0; i < leafCount; i++) {
      final x = centerX + (random.nextDouble() - 0.5) * 60;
      final y = topY + (random.nextDouble() - 0.5) * 40;

      canvas.drawCircle(Offset(x, y), 3 + random.nextDouble() * 2, leafPaint);
    }
  }

  void _drawFlowers(
      Canvas canvas, double centerX, double topY, math.Random random) {
    final flowerPaint = Paint()
      ..color = const Color(0xFFFFB6C1)
      ..style = PaintingStyle.fill;

    final flowerCount = ((tree.growth - 4.0) * 5).round();

    for (int i = 0; i < flowerCount; i++) {
      final x = centerX + (random.nextDouble() - 0.5) * 50;
      final y = topY + (random.nextDouble() - 0.5) * 30;

      canvas.drawCircle(Offset(x, y), 2 + random.nextDouble(), flowerPaint);
    }
  }

  void _drawFruits(
      Canvas canvas, double centerX, double topY, math.Random random) {
    final fruitPaint = Paint()
      ..color = const Color(0xFFFF6347)
      ..style = PaintingStyle.fill;

    final fruitCount = ((tree.growth - 5.0) * 3).round();

    for (int i = 0; i < fruitCount; i++) {
      final x = centerX + (random.nextDouble() - 0.5) * 40;
      final y = topY + (random.nextDouble() - 0.5) * 20;

      canvas.drawCircle(Offset(x, y), 3 + random.nextDouble() * 2, fruitPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SimpleTreePainter oldDelegate) {
    return oldDelegate.tree.growth != tree.growth ||
        oldDelegate.tree.seed != tree.seed;
  }
}
