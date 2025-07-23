import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/meditation/presentation/widgets/soul_garden/river.dart';
import 'package:mental_health/features/meditation/presentation/widgets/soul_garden/tree.dart';

class SoulTreeScreen extends StatefulWidget {
  const SoulTreeScreen({Key? key}) : super(key: key);

  @override
  State<SoulTreeScreen> createState() => _SoulTreeScreenState();
}

class _SoulTreeScreenState extends State<SoulTreeScreen>
    with TickerProviderStateMixin {
  late AnimationController _treeAnimationController;
  late Animation<double> _treeGrowthAnimation;
  late AnimationController _leafAnimationController;
  late Animation<double> _leafFloatAnimation;

  @override
  void initState() {
    super.initState();
    // Animation cho cây phát triển
    _treeAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _treeGrowthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _treeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Animation cho lá bay
    _leafAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _leafFloatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _leafAnimationController,
      curve: Curves.easeInOut,
    ));
    // Bắt đầu animations
    _treeAnimationController.forward();
    _leafAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _treeAnimationController.dispose();
    _leafAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Vườn Tâm Hồn',
          style: TextPresets.titleLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              child: const TreeWidget(
                growth: 1, // Cây đã phát triển 80%
                root: 0.5,
                body: 0.6,
                branch: 0.7,
                leaf: 0.7,
                flower: 0.8,
                fruit: 0.9,
                size: 1,
                seed: 1, // Seed để tạo hình dạng cây nhất quán
              ),
            )
          ],
        ),
      ),
    );
  }
}
