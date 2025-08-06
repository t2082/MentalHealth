import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LakeSurface extends StatefulWidget {
  const LakeSurface({super.key});

  @override
  State<LakeSurface> createState() => _LakeSurfaceState();
}

class _LakeSurfaceState extends State<LakeSurface>
    with TickerProviderStateMixin {
  final List<WaveRipple> _ripples = [];
  final List<JumpingFish> _fishes = [];
  Timer? _waveTimer;
  Timer? _fishTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startWaveTimer();
    _startFishTimer();
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    _fishTimer?.cancel();
    for (var ripple in _ripples) {
      ripple.controller.dispose();
    }
    for (var fish in _fishes) {
      fish.controller.dispose();
    }
    super.dispose();
  }

  void _startWaveTimer() {
    _waveTimer = Timer.periodic(
      Duration(
          milliseconds: 500 +
              _random.nextInt(500)), // 2-4 seconds (faster for multiple waves)
      (timer) {
        _createWave();
        // Update timer interval for next wave
        timer.cancel();
        _startWaveTimer();
      },
    );
  }

  void _startFishTimer() {
    _fishTimer = Timer.periodic(
      Duration(milliseconds: 6000 + _random.nextInt(4000)), // 6-10 seconds
      (timer) {
        _createRandomFishes();
        // Update timer interval for next fish batch
        timer.cancel();
        _startFishTimer();
      },
    );
  }

  void _createWave() {
    if (!mounted) return;

    // Remove completed ripples
    _ripples.removeWhere((ripple) => ripple.controller.isCompleted);

    // Limit maximum number of concurrent waves to 2
    if (_ripples.length >= 20) {
      return;
    }

    // Create new wave at random position
    final ripple = WaveRipple(
      center: Offset(
        _random.nextDouble(),
        _random.nextDouble(),
      ),
      vsync: this,
    );

    setState(() {
      _ripples.add(ripple);
    });

    ripple.controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _ripples.remove(ripple);
        });
        ripple.controller.dispose();
      }
    });
  }

  void _createRandomFishes() {
    if (!mounted) return;

    // Remove completed fishes
    _fishes.removeWhere((fish) => fish.controller.isCompleted);

    // Random number of fishes (1-3)
    final fishCount = 1 + _random.nextInt(3);

    for (int i = 0; i < fishCount; i++) {
      // Add small delay between each fish creation for natural effect
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (!mounted) return;
        _createSingleFish();
      });
    }
  }

  void _createSingleFish() {
    if (!mounted) return;

    // Create new fish at random position
    final fish = JumpingFish(
      position: Offset(
        _random.nextDouble() * 0.8, // Keep within 80% of width
        _random.nextDouble() * 0.8, // Keep within 80% of height
      ),
      vsync: this,
    );

    setState(() {
      _fishes.add(fish);
    });

    fish.controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _fishes.remove(fish);
        });
        fish.controller.dispose();
      }
    });
  }

  void _createWaveAtPosition(Offset position, Size containerSize) {
    if (!mounted) return;

    // Convert tap position to normalized coordinates (0-1)
    final normalizedPosition = Offset(
      (position.dx / containerSize.width).clamp(0.0, 1.0),
      (position.dy / containerSize.height).clamp(0.0, 1.0),
    );

    // Create wave at tap position
    final ripple = WaveRipple(
      center: normalizedPosition,
      vsync: this,
    );

    setState(() {
      _ripples.add(ripple);
    });

    ripple.controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _ripples.remove(ripple);
        });
        ripple.controller.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        // Get the container size and tap position
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final containerSize = renderBox.size;
        final localPosition = details.localPosition;

        _createWaveAtPosition(localPosition, containerSize);
      },
      child: Container(
        width: double.infinity,
        height: 300,
        child: Stack(
          children: [
            CustomPaint(
              painter: LakeSurfacePainter(_ripples),
              size: Size.infinite,
            ),
            ..._fishes.map((fish) => _buildFishWidget(fish)),
          ],
        ),
      ),
    );
  }

  Widget _buildFishWidget(JumpingFish fish) {
    return AnimatedBuilder(
      animation: fish.animation,
      builder: (context, child) {
        // Calculate position within container bounds
        final containerWidth =
            MediaQuery.of(context).size.width - 32; // Subtract padding
        const containerHeight = 300.0;
        const fishWidth = 200.0;
        const fishHeight = 200.0;

        final left = (fish.position.dx * (containerWidth - fishWidth))
            .clamp(0.0, containerWidth - fishWidth)
            .toDouble();
        final top = (fish.position.dy * (containerHeight - fishHeight))
            .clamp(0.0, containerHeight - fishHeight)
            .toDouble();

        return Positioned(
          left: left,
          top: top,
          child: Transform.scale(
            scale: 0.5 + (fish.animation.value * 0.5), // Scale from 0.5 to 1.0
            child: Opacity(
              opacity: 1.0 -
                  fish.animation.value, // Fade out as animation progresses
              child: SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset(
                  'assets/lotties/jumping_fish.json',
                  fit: BoxFit.contain,
                  repeat: false, // Single animation
                  animate: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class JumpingFish {
  final Offset position;
  final AnimationController controller;
  late final Animation<double> animation;

  JumpingFish({
    required this.position,
    required TickerProvider vsync,
  }) : controller = AnimationController(
          duration: const Duration(
              milliseconds: 2000), // 2 seconds for fish animation
          vsync: vsync,
        ) {
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }
}

class WaveRipple {
  final Offset center;
  final AnimationController controller;
  late final Animation<double> animation;

  WaveRipple({
    required this.center,
    required TickerProvider vsync,
  }) : controller = AnimationController(
          duration:
              const Duration(milliseconds: 3000), // Tăng từ 2000ms lên 3000ms
          vsync: vsync,
        ) {
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));
  }
}

class LakeSurfacePainter extends CustomPainter {
  final List<WaveRipple> ripples;

  LakeSurfacePainter(this.ripples) : super(repaint: _getListenable(ripples));

  static Listenable _getListenable(List<WaveRipple> ripples) {
    if (ripples.isEmpty) return ChangeNotifier();
    return Listenable.merge(ripples.map((r) => r.animation).toList());
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var ripple in ripples) {
      _paintRipple(canvas, size, ripple);
    }
  }

  void _paintRipple(Canvas canvas, Size size, WaveRipple ripple) {
    final progress = ripple.animation.value;
    if (progress == 0) return;

    final center = Offset(
      ripple.center.dx * size.width,
      ripple.center.dy * size.height,
    );

    // Create multiple concentric ellipses for wave effect
    for (int i = 0; i < 3; i++) {
      final delay = i * 0.2;
      final waveProgress = (progress - delay).clamp(0.0, 1.0);

      if (waveProgress > 0) {
        final maxRadius = size.width * 0.3;
        final radiusX = maxRadius * waveProgress;
        final radiusY = maxRadius * waveProgress * 0.6; // Elliptical shape

        final opacity =
            (1.0 - waveProgress) * 0.2; // Giảm opacity từ 0.6 xuống 0.2

        final paint = Paint()
          ..color = Colors.blue.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 - (waveProgress * 0.5); // Giảm stroke width

        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radiusX * 2,
            height: radiusY * 2,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant LakeSurfacePainter oldDelegate) {
    return ripples != oldDelegate.ripples;
  }
}
